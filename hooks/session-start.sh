#!/bin/bash
# SessionStart Hook: Initialize environment and load project context
# Runs at the start of each new or resumed session

# Read input JSON
INPUT=$(cat)

# Extract session information (using correct field names from official schema)
SESSION_ID=$(echo "$INPUT" | jq -r '.session_id // "unknown"')
PROJECT_DIR=$(echo "$INPUT" | jq -r '.workspace.project_dir // "."')
CWD=$(echo "$INPUT" | jq -r '.cwd // "."')

# Log session start (optional - comment out if you don't want logging)
# echo "[$(date '+%Y-%m-%d %H:%M:%S')] Session started: $SESSION_ID in $PROJECT_DIR" >> ~/.claude/logs/sessions.log

# Use CLAUDE_ENV_FILE if provided, otherwise create temporary file
if [ -n "$CLAUDE_ENV_FILE" ]; then
    ENV_FILE="$CLAUDE_ENV_FILE"
else
    ENV_FILE="/tmp/claude_env_${SESSION_ID}.sh"
fi

# Set up environment variables
# These will be available to Claude during the session
cat >> "$ENV_FILE" << 'EOF'
# Project-specific environment variables
export EDITOR=nvim
export CLAUDE_SESSION_INITIALIZED=1

# Add any custom environment variables here
# export PROJECT_ENV=production
EOF

# Output additional context for Claude (using official hookSpecificOutput format)
cat <<'EOF'
{
  "hookSpecificOutput": {
    "hookEventName": "SessionStart",
    "additionalContext": "Environment initialized for session"
  }
}
EOF

exit 0
