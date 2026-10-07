---
name: zoekt
description: Fast local code search across indexed repositories with Zoekt. Use before broad rg/find exploration when searching symbols, implementation patterns, or cross-repository references.
---

# Zoekt code search

Use Zoekt for broad, read-only code discovery. It searches an index, not the working tree directly.

## Search

```bash
zoekt -index_dir ~/.zoekt -jsonl 'query'
```

Useful query forms:

- `wallet` — text search
- `"facilitator fee"` — phrase search
- `wallet file:*.go` — file filter
- `wallet repo:transfers-config` — repository filter
- `wallet -file:test` — exclude test files
- `foo or bar` / `-generated` — boolean terms

For a compact result set, add `-l` for matching filenames or pipe JSONL through `jq`.

## Index maintenance

The canonical local index is `~/.zoekt`. Reindex all repositories below `~/github.com` with:

```bash
zoekt-local-sync -index ~/.zoekt -f ~/github.com
```

Preview changes first by omitting `-f`. This sync treats the supplied roots as the complete desired repository set and removes indexed repositories no longer found below them. Use a narrower root when appropriate.

For one repository:

```bash
zoekt-git-index -index ~/.zoekt /absolute/path/to/repository
```

## Agent workflow

1. Use `zoekt` for cross-repository discovery and likely symbol/file locations.
2. Use `rg` or `read` in the target repository for exact context and line-level verification.
3. Never treat index results as current without checking the working tree; reindex after substantial changes.
4. Search is read-only; do not modify or delete index data unless the user asks.
