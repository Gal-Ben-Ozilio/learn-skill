#!/usr/bin/env bash
# UserPromptSubmit hook
# Injects a /learn nudge into Claude's context when key conditions are met.
# stdout → injected as context for Claude's next response.
# No output = no injection = no cost.

set -euo pipefail

NUDGE_PENDING="$HOME/.claude/learn-nudge-pending"
NUDGE_TIME_FILE="$HOME/.claude/learn-nudge-time"
SESSION_START_FILE="$HOME/.claude/learn-session-start"

# Track session start time (written once per session using CLAUDE_SESSION_ID)
if [[ -n "${CLAUDE_SESSION_ID:-}" ]]; then
    SESSION_MARKER="$HOME/.claude/learn-session-${CLAUDE_SESSION_ID}"
    if [[ ! -f "$SESSION_MARKER" ]]; then
        date +%s > "$SESSION_MARKER"
        # Clean up old session markers (keep last 20)
        ls -t "$HOME/.claude/learn-session-"* 2>/dev/null | tail -n +21 | xargs rm -f 2>/dev/null || true
    fi
    SESSION_START=$(cat "$SESSION_MARKER" 2>/dev/null || date +%s)
else
    SESSION_START=$(date +%s)
fi

NOW=$(date +%s)

# --- Condition 1: PR was created ---
if [[ -f "$NUDGE_PENDING" ]]; then
    REASON=$(python3 -c "
import sys, json
try:
    data = json.load(open('$NUDGE_PENDING'))
    print(data.get('reason','event'))
except Exception:
    print('event')
" 2>/dev/null || echo "event")

    rm -f "$NUDGE_PENDING"

    echo "[/learn nudge] A pull request was just created in this session. This is a natural checkpoint — consider proactively suggesting to the user that now is a good time to run /learn to capture any patterns, decisions, or conventions from this session before it ends."
    exit 0
fi

# --- Condition 2: Session has been running > 30 minutes ---
SESSION_AGE=$(( NOW - SESSION_START ))
THIRTY_MIN=1800

if (( SESSION_AGE > THIRTY_MIN )); then
    # Throttle: only nudge once per session
    if [[ ! -f "$NUDGE_TIME_FILE" ]]; then
        touch "$NUDGE_TIME_FILE"
        # Clean up on session end (best effort)
        LAST_NUDGE_SESSION="${CLAUDE_SESSION_ID:-unknown}"
        echo "$LAST_NUDGE_SESSION" >> "$NUDGE_TIME_FILE"

        echo "[/learn nudge] This session has been running for more than 30 minutes and likely contains valuable learnings. Consider proactively suggesting to the user that they run /learn to capture any patterns, decisions, or preferences from this session."
        exit 0
    fi
fi

# No conditions met — exit silently (no stdout = no injection, no tokens)
exit 0
