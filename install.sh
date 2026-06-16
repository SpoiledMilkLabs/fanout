#!/usr/bin/env bash
set -euo pipefail

# fanout installer
# Copies the fanout, fanoutpro, and fanoutmax skills into ~/.claude/skills/
# Then restart Claude Code — the /fanout, /fanoutpro, /fanoutmax commands are live.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="${HOME}/.claude"

echo "==> fanout installer"
echo "    Source: ${SCRIPT_DIR}"
echo "    Target: ${CLAUDE_DIR}/skills/"
echo ""

if [ ! -d "${SCRIPT_DIR}/skills" ]; then
  echo "[error] skills/ directory not found in repo root"
  exit 1
fi

installed=0
for skill_dir in "${SCRIPT_DIR}/skills"/*/; do
  [ -f "${skill_dir}SKILL.md" ] || continue
  skill_name=$(basename "$skill_dir")
  mkdir -p "${CLAUDE_DIR}/skills/${skill_name}"
  cp "${skill_dir}SKILL.md" "${CLAUDE_DIR}/skills/${skill_name}/SKILL.md"
  echo "[ok] /${skill_name} -> ${CLAUDE_DIR}/skills/${skill_name}/SKILL.md"
  installed=$((installed + 1))
done

echo ""
echo "Installed ${installed} skill(s). Restart Claude Code to activate."
echo ""
echo "Commands available after restart:"
echo "  /fanout     — parallel decomposition, speed tier"
echo "  /fanoutpro  — adds pre-flight context, lens specialization, cross-validation"
echo "  /fanoutmax  — adversarial verification, completeness critic, loop-until-dry"
echo ""
echo "==> Done."
