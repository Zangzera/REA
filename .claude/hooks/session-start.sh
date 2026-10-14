#!/bin/bash
# Prepare a Claude Code cloud session: locked dependencies plus the compiled
# runtime that the project `.mcp.json` server (`scripts/rea.mjs mcp`) needs.
set -euo pipefail

if [ "${CLAUDE_CODE_REMOTE:-}" != "true" ]; then
  exit 0
fi

cd "${CLAUDE_PROJECT_DIR:-$(dirname "$0")/../..}"

# Reinstall only when installed direct dependencies differ from the lockfile.
if [ ! -f node_modules/.package-lock.json ] ||
  ! node scripts/check-dependency-install.mjs >/dev/null 2>&1; then
  npm ci --no-audit --no-fund
fi

npm run build:cached
