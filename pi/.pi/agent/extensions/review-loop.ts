import { execFileSync, spawnSync } from "node:child_process";
import { closeSync, existsSync, lstatSync, mkdirSync, mkdtempSync, openSync, readFileSync, rmSync, statSync, writeFileSync } from "node:fs";
import { tmpdir } from "node:os";
import { dirname, join, resolve } from "node:path";
import { gzipSync, gunzipSync } from "node:zlib";
import type { ExtensionAPI, ExtensionContext } from "@earendil-works/pi-coding-agent";

const CHECKPOINT = "review-loop/checkpoint";
const RESET = "review-loop/reset";
const ANNOTATION_EXIT_CODE = 10;
const ANNOTATION_ENV = "REVDIFF_EXIT_CODE_ON_ANNOTATIONS";

type StoredFile = { state: "deleted" } | { state: "present"; content: string };
type ReviewCheckpoint = {
	version: 1;
	repoRoot: string;
	headSha: string | null;
	overrides: Record<string, StoredFile>;
	createdAt: number;
};

type ReviewMode = "full" | "next";

function run(command: string, args: string[], cwd: string): string {
	return execFileSync(command, args, {
		cwd,
		encoding: "utf8",
		maxBuffer: 100 * 1024 * 1024,
		stdio: ["ignore", "pipe", "pipe"],
	});
}

function git(cwd: string, args: string[]): string {
	return run("git", args, cwd);
}

function repoRoot(cwd: string): string {
	return git(cwd, ["rev-parse", "--show-toplevel"]).trim();
}

function headSha(cwd: string): string | null {
	try {
		return git(cwd, ["rev-parse", "--verify", "HEAD"]).trim() || null;
	} catch {
		return null;
	}
}

function zeroList(value: string): string[] {
	return value.split("\0").filter(Boolean);
}

function isRegularFile(cwd: string, path: string): boolean {
	try {
		return statSync(join(cwd, path)).isFile();
	} catch {
		return false;
	}
}

function lstatExists(cwd: string, path: string): boolean {
	try {
		lstatSync(join(cwd, path));
		return true;
	} catch {
		return false;
	}
}

function currentPaths(cwd: string): string[] {
	return zeroList(git(cwd, ["ls-files", "--cached", "--others", "--exclude-standard", "-z"]))
		.filter((path) => isRegularFile(cwd, path));
}

function dirtyPaths(cwd: string): string[] {
	const tracked = headSha(cwd)
		? zeroList(git(cwd, ["diff", "--name-only", "-z", "HEAD", "--"]))
		: [];
	const untracked = zeroList(git(cwd, ["ls-files", "--others", "--exclude-standard", "-z"]));
	return [...new Set([...tracked, ...untracked])]
		.filter((path) => !lstatExists(cwd, path) || isRegularFile(cwd, path));
}

function stored(content: string | null): StoredFile {
	return content == null
		? { state: "deleted" }
		: { state: "present", content: gzipSync(Buffer.from(content)).toString("base64") };
}

function restore(file: StoredFile): string | null {
	return file.state === "deleted" ? null : gunzipSync(Buffer.from(file.content, "base64")).toString("utf8");
}

function readCurrent(cwd: string, path: string): string | null {
	if (!isRegularFile(cwd, path)) return null;
	try {
		return readFileSync(join(cwd, path), "utf8");
	} catch {
		return null;
	}
}

function writeTree(root: string, files: Record<string, string | null>): void {
	for (const [path, content] of Object.entries(files)) {
		const target = join(root, path);
		if (content == null) {
			rmSync(target, { recursive: true, force: true });
			continue;
		}
		mkdirSync(dirname(target), { recursive: true });
		rmSync(target, { recursive: true, force: true });
		writeFileSync(target, content);
	}
}

function archiveHead(cwd: string, target: string, sha: string | null): void {
	if (sha == null) return;
	const archive = join(target, ".review-head.tar");
	const archiveFd = openSync(archive, "w");
	try {
		execFileSync("git", ["archive", sha], { cwd, stdio: ["ignore", archiveFd, "inherit"] });
	} finally {
		closeSync(archiveFd);
	}
	execFileSync("tar", ["-xf", archive, "-C", target]);
	rmSync(archive, { force: true });
}

function removeTreeExceptGit(root: string): void {
	for (const name of execFileSync("find", [root, "-mindepth", "1", "-maxdepth", "1", "-not", "-name", ".git", "-print"], { encoding: "utf8" }).split("\n")) {
		if (name) rmSync(name, { recursive: true, force: true });
	}
}

function materializeBaseline(cwd: string, checkpoint: ReviewCheckpoint | null, target: string): void {
	const sha = checkpoint?.headSha ?? headSha(cwd);
	archiveHead(cwd, target, sha);
	if (checkpoint) {
		const overrides: Record<string, string | null> = {};
		for (const [path, file] of Object.entries(checkpoint.overrides)) overrides[path] = restore(file);
		writeTree(target, overrides);
	}
}

function materializeCurrent(cwd: string, target: string): void {
	archiveHead(cwd, target, headSha(cwd));
	const tracked = new Set(zeroList(git(cwd, ["ls-files", "-z"])));
	for (const path of tracked) {
		if (!existsSync(join(cwd, path))) rmSync(join(target, path), { recursive: true, force: true });
	}
	const files: Record<string, string | null> = {};
	for (const path of currentPaths(cwd)) files[path] = readCurrent(cwd, path);
	writeTree(target, files);
}

export function createPatch(cwd: string, checkpoint: ReviewCheckpoint | null): string {
	const temp = mkdtempSync(join(tmpdir(), "pi-review-loop-"));
	try {
		const oldTree = join(temp, "old");
		mkdirSync(oldTree);
		materializeBaseline(cwd, checkpoint, oldTree);
		const repo = join(temp, "repo");
		mkdirSync(repo);
		run("git", ["init", "-q"], repo);
		run("git", ["config", "user.email", "review-loop@localhost"], repo);
		run("git", ["config", "user.name", "Review Loop"], repo);
		for (const name of execFileSync("find", [oldTree, "-mindepth", "1", "-maxdepth", "1", "-print"], { encoding: "utf8" }).split("\n")) {
			if (name) execFileSync("cp", ["-R", name, repo]);
		}
		run("git", ["add", "-A"], repo);
		run("git", ["commit", "-qm", "--allow-empty", "-m", "review baseline"], repo);
		removeTreeExceptGit(repo);
		materializeCurrent(cwd, repo);
		run("git", ["add", "-A"], repo);
		return git(repo, ["diff", "--cached", "--binary", "--no-ext-diff"]);
	} finally {
		rmSync(temp, { recursive: true, force: true });
	}
}

export function checkpointFor(cwd: string): ReviewCheckpoint {
	const overrides: Record<string, StoredFile> = {};
	for (const path of dirtyPaths(cwd)) overrides[path] = stored(readCurrent(cwd, path));
	return { version: 1, repoRoot: repoRoot(cwd), headSha: headSha(cwd), overrides, createdAt: Date.now() };
}

function latestCheckpoint(ctx: ExtensionContext, root: string): ReviewCheckpoint | null {
	for (const entry of [...ctx.sessionManager.getBranch()].reverse()) {
		if (entry.type === "custom" && entry.customType === RESET) return null;
		if (entry.type !== "custom" || entry.customType !== CHECKPOINT) continue;
		const value = entry.data as Partial<ReviewCheckpoint>;
		if (value.version === 1 && value.repoRoot === root) return value as ReviewCheckpoint;
	}
	return null;
}

function findRevdiff(): string | undefined {
	const configured = process.env.REVDIFF_BIN;
	if (configured && existsSync(configured)) return configured;
	for (const dir of (process.env.PATH ?? "").split(":")) {
		const candidate = join(dir, "revdiff");
		if (existsSync(candidate)) return candidate;
	}
	return undefined;
}

function parseAnnotationCount(output: string): number {
	return output.split(/\r?\n/).filter((line) => /^## .+ \([^)]+\)$/.test(line)).length;
}

function resolveReviewRoot(baseCwd: string, rawPath: string): string {
	const requested = rawPath.trim();
	if (!requested) return repoRoot(baseCwd);

	const candidates = [
		resolve(baseCwd, requested),
		resolve(baseCwd, "..", requested),
		process.env.REPO_GALLERY_DIR ? resolve(process.env.REPO_GALLERY_DIR, requested) : null,
	].filter((candidate): candidate is string => candidate != null);
	let lastError: unknown;
	for (const candidate of [...new Set(candidates)]) {
		if (!existsSync(candidate)) continue;
		try {
			return repoRoot(candidate);
		} catch (error) {
			lastError = error;
		}
	}
	throw lastError ?? new Error(`Repository not found: ${requested}`);
}

async function launchReview(
	ctx: ExtensionContext,
	reviewRoot: string,
	mode: ReviewMode,
	checkpoint: ReviewCheckpoint | null,
): Promise<{ annotations: string; hadDiff: boolean }> {
	const patch = createPatch(reviewRoot, mode === "full" ? null : checkpoint);
	if (!patch.trim()) {
		ctx.ui.notify(mode === "full" ? "No working-tree changes to review." : "No changes since the last review.", "info");
		return { annotations: "", hadDiff: false };
	}
	const revdiff = findRevdiff();
	if (!revdiff) throw new Error("revdiff binary not found; install it or set REVDIFF_BIN");

	const temp = mkdtempSync(join(tmpdir(), "revdiff-review-loop-"));
	const output = join(temp, "annotations.md");
	try {
		const status = await ctx.ui.custom<number | null>((tui, _theme, _keybindings, done) => {
			tui.stop();
			process.stdout.write("\x1b[2J\x1b[H");
			const result = spawnSync(revdiff, ["--stdin", `--output=${output}`], {
				cwd: reviewRoot,
				input: patch,
				env: { ...process.env, [ANNOTATION_ENV]: "true" },
				stdio: ["pipe", "inherit", "inherit"],
			});
			tui.start();
			tui.requestRender(true);
			done(result.status ?? 1);
			return { render: () => [], invalidate() {} };
		});
		if (status !== 0 && status !== ANNOTATION_EXIT_CODE) throw new Error(`revdiff exited with code ${status}`);
		const annotations = existsSync(output) ? readFileSync(output, "utf8").trim() : "";
		return { annotations, hadDiff: true };
	} finally {
		rmSync(temp, { recursive: true, force: true });
	}
}

export default function reviewLoop(pi: ExtensionAPI): void {
	let automaticReview: { mode: ReviewMode; root: string } | null = null;
	let running = false;

	const review = async (mode: ReviewMode, rawPath: string, ctx: ExtensionContext): Promise<void> => {
		if (running) return;
		running = true;
		try {
			const root = resolveReviewRoot(ctx.cwd, rawPath);
			const checkpoint = latestCheckpoint(ctx, root);
			const result = await launchReview(ctx, root, mode, checkpoint);
			if (!result.hadDiff) {
				automaticReview = null;
				return;
			}
			pi.appendEntry(CHECKPOINT, checkpointFor(root));
			const count = parseAnnotationCount(result.annotations);
			if (count === 0) {
				automaticReview = null;
				ctx.ui.notify("Review complete; checkpoint saved.", "info");
				return;
			}
			automaticReview = { mode, root };
			pi.sendUserMessage(
				`Review Loop captured ${count} annotation${count === 1 ? "" : "s"} for ${root}. Apply the requested changes, then wait for the next review pass.\n\n${result.annotations}`,
			);
		} catch (error) {
			automaticReview = null;
			ctx.ui.notify(`Review Loop failed: ${error instanceof Error ? error.message : String(error)}`, "error");
		} finally {
			running = false;
		}
	};

	pi.registerCommand("review-next", {
		description: "Review changes since the last checkpoint (optional repository path)",
		handler: async (args, ctx) => review("next", args, ctx),
	});
	pi.registerCommand("review-full", {
		description: "Review the complete change from HEAD (optional repository path)",
		handler: async (args, ctx) => review("full", args, ctx),
	});
	pi.registerCommand("review-reset", {
		description: "Reset the Review Loop checkpoint",
		handler: async (_args, ctx) => {
		pi.appendEntry(RESET, { version: 1, createdAt: Date.now() });
		automaticReview = null;
		ctx.ui.notify("Review Loop checkpoint reset.", "info");
	},
	});

	pi.on("agent_settled", async (_event, ctx) => {
		if (automaticReview == null || running || ctx.mode !== "tui") return;
		const pending = automaticReview;
		automaticReview = null;
		await review(pending.mode, pending.root, ctx);
	});
}
