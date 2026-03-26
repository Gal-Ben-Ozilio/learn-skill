#!/usr/bin/env bash
set -e

SKILLS_DIR="$HOME/.claude/skills"
RULES_DIR="$HOME/.claude/rules"
SKILL_NAME="learn"
SKILL_DIR="$SKILLS_DIR/$SKILL_NAME"
REPO_URL="https://github.com/Gal-Ben-Ozilio/learn-skill"
SETTINGS_FILE="$HOME/.claude/settings.json"

echo "Installing /$SKILL_NAME skill for Claude Code..."

# --- 1. Install skill files ---

mkdir -p "$SKILLS_DIR"

if [ -d "$SKILL_DIR" ] || [ -L "$SKILL_DIR" ]; then
  rm -rf "$SKILL_DIR"
fi

git clone --depth=1 "$REPO_URL" "$SKILL_DIR"
rm -rf "$SKILL_DIR/.git"

echo "  Skill installed at $SKILL_DIR"

# --- 2. Write global learn-habit rule ---

mkdir -p "$RULES_DIR"
cat > "$RULES_DIR/learn-habit.md" << 'EOF'
# /learn Habit

Proactively suggest running /learn at natural session checkpoints:
- After creating a pull request (`gh pr create`)
- After completing a significant feature or bug fix
- After making an important architectural decision
- When the conversation has been long and productive (30+ minutes)

When suggesting, say something like:
"This feels like a good moment to run /learn — want me to extract and save the learnings from this session?"

If the user agrees or asks you to proceed, invoke the /learn skill directly.
EOF

echo "  Global rule written to $RULES_DIR/learn-habit.md"

# --- 3. Register hooks in ~/.claude/settings.json ---

HOOK_TRACK="bash \"$SKILL_DIR/hooks/scripts/track-session-events.sh\""
HOOK_NUDGE="bash \"$SKILL_DIR/hooks/scripts/inject-learn-nudge.sh\""

# Use Python to safely merge hooks into existing settings.json
python3 << PYEOF
import json, os, sys

settings_file = "$SETTINGS_FILE"

# Load existing settings
if os.path.exists(settings_file):
    with open(settings_file) as f:
        try:
            settings = json.load(f)
        except json.JSONDecodeError:
            settings = {}
else:
    settings = {}

hooks = settings.setdefault("hooks", {})

# PostToolUse — track gh pr create
post_tool_use = hooks.setdefault("PostToolUse", [])
track_hook = {
    "matcher": "Bash",
    "hooks": [{
        "type": "command",
        "command": "$HOOK_TRACK",
        "async": True
    }]
}
# Remove existing learn track hook if present, then add fresh
hooks["PostToolUse"] = [h for h in post_tool_use if "$SKILL_DIR/hooks/scripts/track-session-events" not in str(h)]
hooks["PostToolUse"].append(track_hook)

# UserPromptSubmit — inject nudge
user_prompt = hooks.setdefault("UserPromptSubmit", [])
nudge_hook = {
    "type": "command",
    "command": "$HOOK_NUDGE",
    "timeout": 3
}
hooks["UserPromptSubmit"] = [h for h in user_prompt if "$SKILL_DIR/hooks/scripts/inject-learn-nudge" not in str(h)]
hooks["UserPromptSubmit"].append(nudge_hook)

settings["hooks"] = hooks

with open(settings_file, "w") as f:
    json.dump(settings, f, indent=2)
    f.write("\n")

print("  Hooks registered in $SETTINGS_FILE")
PYEOF

# --- Done ---

echo ""
echo "Done! /learn is installed with smart auto-suggestion:"
echo "  - Claude will proactively suggest /learn after PRs, decisions, and long sessions"
echo "  - Hooks fire automatically on gh pr create and after 30min sessions"
echo ""
echo "Start a new Claude Code session to activate. Type /learn to use manually."
