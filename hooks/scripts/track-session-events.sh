#!/usr/bin/env bash
# PostToolUse hook (Bash matcher)
# Detects gh pr create and writes a nudge flag for inject-learn-nudge.sh to pick up.
# Runs async — no latency impact, no output.

set -euo pipefail

INPUT=$(cat)

# Extract the bash command from the tool input JSON
COMMAND=$(echo "$INPUT" | python3 -c "
import sys, json
try:
    data = json.load(sys.stdin)
    cmd = data.get('tool_input', {}).get('command', '')
    print(cmd)
except Exception:
    print('')
" 2>/dev/null || echo "")

# Check if this was a gh pr create command
if echo "$COMMAND" | grep -q "gh pr create"; then
    echo "{\"reason\":\"pr_created\",\"timestamp\":\"$(date -u +%Y-%m-%dT%H:%M:%SZ)\"}" \
        > "$HOME/.claude/learn-nudge-pending"
fi

exit 0
