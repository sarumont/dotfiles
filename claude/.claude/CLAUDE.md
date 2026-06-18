@~/AGENTS.md
@RTK.md

# Global Claude Code Instructions

## Preferred Tools & Auto-Install via Homebrew

Before falling back to Python scripts or sed for file manipulation, check
for and prefer these tools. If a preferred tool is not installed, suggest
installing it via Homebrew before proceeding with an inferior alternative.

### File Editing
- **Edit tool** — always first choice for single precise edits
- **codemod** — bulk pattern replacement across files
  - Check: `which codemod`
  - Install: `brew install codemod`
  - Run directly: `codemod 'pattern' 'replacement' dir/` — do NOT wrap in
    shell scaffolding (2>&1, echo exit codes, etc.) as this breaks pre-approval

### Data Formats
- **jq** — JSON querying and manipulation
  - Check: `which jq`
  - Install: `brew install jq`
- **yq** — YAML querying and manipulation
  - Check: `which yq`
  - Install: `brew install yq`
- **yamllint** — YAML validation and linting; always use instead of Python for YAML validation
  - Check: `which yamllint`
  - Install: `brew install yamllint`

### Search
- **ripgrep (rg)** — fast file content search, use before Edit to confirm
  exact match strings. Use instead of `grep`
  - Check: `which rg`
  - Install: `brew install ripgrep`

### Text Replacement
- **sd** — modern sed alternative with sane regex syntax, pre-approved in settings.json
  - Check: `which sd`
  - Install: `brew install sd`

### Behavior
- If a preferred tool is missing, say so and offer to install it via
  Homebrew before falling back to Python or sed
- Never write a temporary Python script solely to edit or transform files
  when the above tools are available
- Never use sed — use sd instead (it is pre-approved and will not prompt)

## Bash Tool — Exit Codes and Output Capture

Claude Code's Bash tool automatically returns stdout, stderr, and the exit
code as part of every tool result. Therefore:
- Never append `echo "exit: $?"` — the exit code is already available
- Never use `2>&1` to capture stderr — it is already captured separately
- Never wrap commands in diagnostic scaffolding just to observe results
- Run commands directly: `codemod 'a' 'b' src/` not `codemod 'a' 'b' src/ 2>&1 && echo $?`
- Wrapping pre-approved tools in shell expressions breaks pattern matching
  and causes unnecessary approval prompts

## File Editing — Approval Avoidance

The Edit and Write tools require NO Bash execution and NO approval prompts.
Bash-based tools ALL require approval unless pre-approved in settings.json.

### Decision rule — follow strictly:
1. Single location edit → use Edit tool directly. Never use Bash.
2. Whole file rewrite → use Write tool. Never use Bash.
3. Bulk edits across multiple files → use Edit tool in a loop across
   files. Still no Bash.
4. Only use sd or codemod when regex pattern matching is genuinely
   required AND the Edit tool cannot work. Both are pre-approved.

### The key insight:
Even well-intentioned tools like sd and codemod go through Bash and
would normally trigger approval prompts — but sd, rg, jq, yq, yamllint,
and codemod are pre-approved in settings.json so they will not prompt.
The Edit tool never prompts regardless. Always prefer Edit first.

### When to use Edit tool vs sd:
- Single line replacement → sd is fine and pre-approved
- Multiline pattern (match spans a newline) → Edit tool only, sd will fail
- Uncertain whether pattern is single or multiline → Edit tool to be safe

### What Edit needs to work well:
- Read the file first to get the exact string before attempting an Edit
- Use rg to locate exact content if uncertain about surrounding text
- Make multiple small Edit calls rather than one complex Bash command
- Never construct a Bash command to handle uncertainty — Read first, then Edit
