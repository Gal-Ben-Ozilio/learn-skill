#!/usr/bin/env bash
set -e

SKILLS_DIR="$HOME/.claude/skills"
SKILL_NAME="learn"
REPO_URL="https://github.com/Gal-Ben-Ozilio/learn-skill"

echo "Installing /$SKILL_NAME skill for Claude Code..."

# Create skills directory if it doesn't exist
mkdir -p "$SKILLS_DIR"

# Remove existing installation if present
if [ -d "$SKILLS_DIR/$SKILL_NAME" ] || [ -L "$SKILLS_DIR/$SKILL_NAME" ]; then
  rm -rf "$SKILLS_DIR/$SKILL_NAME"
fi

# Clone into skills directory
git clone --depth=1 "$REPO_URL" "$SKILLS_DIR/$SKILL_NAME"

# Remove the .git folder (not needed for skill usage)
rm -rf "$SKILLS_DIR/$SKILL_NAME/.git"

echo ""
echo "Done! /$SKILL_NAME is now available in Claude Code."
echo "Start a new session and type /learn to use it."
