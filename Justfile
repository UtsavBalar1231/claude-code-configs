# Claude Code Configuration Manager
# Installation and maintenance recipes for personal Claude Code setup

# Default recipe - show available commands
default:
    @just --list

# Install configuration by copying files to ~/.claude
install:
    #!/usr/bin/env bash
    set -e

    TARGET="$HOME/.claude"
    BACKUP="$HOME/.claude.backup.$(date +%Y%m%d_%H%M%S)"

    echo "Installing Claude Code configuration..."

    # Backup existing configuration if present
    if [ -e "$TARGET" ]; then
        echo "Backing up existing configuration to $BACKUP"
        mv "$TARGET" "$BACKUP"
    fi

    # Create target directory
    mkdir -p "$TARGET"

    # Copy all files except .git
    echo "Copying configuration files..."
    rsync -av --exclude='.git' --exclude='Justfile' --exclude='README.md' ./ "$TARGET/"

    echo "Installation complete!"
    echo "Configuration installed to: $TARGET"
    if [ -e "$BACKUP" ]; then
        echo "Previous configuration backed up to: $BACKUP"
    fi
    echo ""
    echo "Next steps:"
    echo "  1. Run 'just plugins' to install required plugins"
    echo "  2. Restart Claude Code to load the new configuration"

# Uninstall configuration from ~/.claude
uninstall:
    #!/usr/bin/env bash
    set -e

    TARGET="$HOME/.claude"
    BACKUP="$HOME/.claude.backup.$(date +%Y%m%d_%H%M%S)"

    if [ ! -e "$TARGET" ]; then
        echo "No configuration found at $TARGET"
        exit 0
    fi

    echo "Uninstalling Claude Code configuration..."
    echo "Moving $TARGET to $BACKUP"
    mv "$TARGET" "$BACKUP"

    echo "[SUCCESS] Uninstallation complete!"
    echo "Configuration backed up to: $BACKUP"

# Update configuration (pull latest changes and reinstall)
update:
    #!/usr/bin/env bash
    set -e

    echo "Updating Claude Code configuration..."

    # Pull latest changes
    echo "Pulling latest changes from git..."
    git pull

    # Reinstall
    echo ""
    just install

# Show plugin installation commands
plugins:
    #!/usr/bin/env bash
    echo "Plugin Installation Instructions"
    echo "================================="
    echo ""
    echo "Run these commands inside Claude Code:"
    echo ""
    echo "  /plugin marketplace add obra/superpowers-marketplace"
    echo "  /plugin install superpowers@superpowers-marketplace"
    echo "  /plugin install episodic-memory@superpowers-marketplace"
    echo ""
    echo "Current plugin versions in this config:"
    echo "  - superpowers: v3.2.3"
    echo "  - episodic-memory: v1.0.5"

# Check installation status
status:
    #!/usr/bin/env bash
    set -e

    TARGET="$HOME/.claude"

    echo "Claude Code Configuration Status"
    echo "================================="
    echo ""

    # Check if installed
    if [ ! -e "$TARGET" ]; then
        echo "Status: NOT INSTALLED"
        echo "Run 'just install' to install the configuration"
        exit 0
    fi

    echo "Status: INSTALLED"
    echo "Location: $TARGET"
    echo ""

    # Check key files
    echo "Core Files:"
    for file in "CLAUDE.md" "settings.json" "statusline.py"; do
        if [ -f "$TARGET/$file" ]; then
            echo "  [SUCCESS] $file"
        else
            echo "  [ERROR] $file (missing)"
        fi
    done
    echo ""

    # Check directories
    echo "Directories:"
    for dir in "skills" "agents" "plugins" "hooks"; do
        if [ -d "$TARGET/$dir" ]; then
            count=$(find "$TARGET/$dir" -mindepth 1 -maxdepth 1 | wc -l)
            echo "  [SUCCESS] $dir/ ($count items)"
        else
            echo "  [ERROR] $dir/ (missing)"
        fi
    done
    echo ""

    # Git status of this repo
    echo "Repository Status:"
    if [ -d ".git" ]; then
        echo "  Branch: $(git branch --show-current)"
        echo "  Latest commit: $(git log -1 --format='%h - %s (%cr)')"
        if [ -n "$(git status --porcelain)" ]; then
            echo "  Status: Has uncommitted changes"
        else
            echo "  Status: Clean"
        fi
    else
        echo "  Not a git repository"
    fi

# Install alternative: create symlinks instead of copying (advanced)
install-symlink:
    #!/usr/bin/env bash
    set -e

    SOURCE="$(pwd)"
    TARGET="$HOME/.claude"
    BACKUP="$HOME/.claude.backup.$(date +%Y%m%d_%H%M%S)"

    echo "Installing Claude Code configuration (symlink mode)..."
    echo "This will symlink ~/.claude -> $SOURCE"
    echo ""

    # Backup existing configuration if present
    if [ -e "$TARGET" ]; then
        echo "Backing up existing configuration to $BACKUP"
        mv "$TARGET" "$BACKUP"
    fi

    # Create symlink
    ln -s "$SOURCE" "$TARGET"

    echo "[SUCCESS] Installation complete!"
    echo "~/.claude -> $SOURCE"
    echo ""
    echo "Note: Changes in this directory will immediately affect Claude Code"
    echo "Next steps:"
    echo "  1. Run 'just plugins' to install required plugins"
    echo "  2. Restart Claude Code to load the new configuration"

# Check MCP server prerequisites
mcp-check:
    #!/usr/bin/env bash

    echo "Checking MCP Server Prerequisites"
    echo "=================================="
    echo ""

    # Check Node.js/npx
    if command -v npx &> /dev/null; then
        echo "[SUCCESS] npx: $(npx --version)"
    else
        echo "[ERROR] npx: Not found (install Node.js)"
    fi

    # Check uv/uvx
    if command -v uvx &> /dev/null; then
        echo "[SUCCESS] uvx: $(uvx --version)"
    else
        echo "[ERROR] uvx: Not found"
        echo "  Install with: curl -LsSf https://astral.sh/uv/install.sh | sh"
    fi

    # Check claude CLI
    if command -v claude &> /dev/null; then
        echo "[SUCCESS] claude: $(command -v claude)"
    else
        echo "[ERROR] claude: Not found (Claude Code CLI not in PATH)"
    fi

    echo ""
    if command -v npx &> /dev/null && command -v uvx &> /dev/null && command -v claude &> /dev/null; then
        echo "All prerequisites satisfied! Run 'just mcp-install' to install MCP servers."
    else
        echo "Some prerequisites are missing. Install them before running 'just mcp-install'."
    fi

# Install all external MCP servers
mcp-install:
    #!/usr/bin/env bash
    set -e

    echo "Installing External MCP Servers"
    echo "================================"
    echo ""

    # Check prerequisites first
    if ! command -v claude &> /dev/null; then
        echo "[ERROR] 'claude' command not found"
        echo "Make sure Claude Code CLI is installed and in your PATH"
        exit 1
    fi

    if ! command -v npx &> /dev/null; then
        echo "[ERROR] 'npx' not found. Please install Node.js"
        exit 1
    fi

    if ! command -v uvx &> /dev/null; then
        echo "[ERROR] 'uvx' not found. Install uv with:"
        echo "  curl -LsSf https://astral.sh/uv/install.sh | sh"
        exit 1
    fi

    echo "Installing MCP servers..."
    echo ""

    # Sequential Thinking
    echo "  Installing sequential-thinking..."
    claude mcp add sequential-thinking npx -y @modelcontextprotocol/server-sequential-thinking || echo "  (may already exist)"

    # Fetch
    echo "  Installing fetch..."
    claude mcp add fetch uvx mcp-server-fetch || echo "  (may already exist)"

    # Git
    echo "  Installing git..."
    claude mcp add git uvx mcp-server-git || echo "  (may already exist)"

    # Filesystem (customize directories as needed)
    echo "  Installing filesystem..."
    claude mcp add filesystem npx -y @modelcontextprotocol/server-filesystem \
        "$HOME/Documents" "$HOME/Desktop" "$HOME/Downloads" "$HOME/Projects" "$HOME/dev" \
        || echo "  (may already exist)"

    # Ref
    echo "  Installing Ref..."
    claude mcp add Ref npx ref-tools-mcp@latest || echo "  (may already exist)"

    # Context7
    echo "  Installing context7..."
    claude mcp add context7 https://mcp.context7.com/mcp --transport http || echo "  (may already exist)"

    echo ""
    echo "[SUCCESS] MCP server installation complete!"
    echo ""
    echo "Run 'just mcp-status' to verify server health."

# Check MCP server health
mcp-status:
    #!/usr/bin/env bash
    set -e

    if ! command -v claude &> /dev/null; then
        echo "[ERROR] 'claude' command not found"
        echo "Make sure Claude Code CLI is installed and in your PATH"
        exit 1
    fi

    echo "Checking MCP Server Health..."
    echo ""
    claude mcp list

# Show differences between ~/.claude and repository
diff:
    #!/usr/bin/env bash
    set -e

    SOURCE="$HOME/.claude"
    TARGET="$(pwd)"

    if [ ! -e "$SOURCE" ]; then
        echo "[ERROR] Configuration not found at $SOURCE"
        echo "Run 'just install' first to install the configuration"
        exit 1
    fi

    echo "Comparing ~/.claude with repository..."
    echo "======================================="
    echo ""
    echo "Source: $SOURCE"
    echo "Target: $TARGET"
    echo ""

    # Use rsync in dry-run mode to show what would be synced
    rsync -avn --delete \
        --exclude='*.pyc' \
        --exclude='.DS_Store' \
        --exclude='.claude/settings.local.json' \
        --exclude='.credentials.json' \
        --exclude='.git' \
        --exclude='.update_check' \
        --exclude='Justfile' \
        --exclude='README.md' \
        --exclude='__pycache__' \
        --exclude='backups/*' \
        --exclude='debug/*' \
        --exclude='file-history/*' \
        --exclude='history.jsonl' \
        --exclude='local/*' \
        --exclude='plugins/cache/*' \
        --exclude='projects/*' \
        --exclude='session-env/*' \
        --exclude='shell-snapshots/*' \
        --exclude='statsig/*' \
        --exclude='todos/*' \
        "$SOURCE/" "$TARGET/" | grep -v '/$' || echo "No differences found"

    echo ""
    echo "Run 'just pull' to sync these changes to the repository"

# Pull configuration changes from ~/.claude to repository
pull:
    #!/usr/bin/env bash
    set -e

    SOURCE="$HOME/.claude"
    TARGET="$(pwd)"

    if [ ! -e "$SOURCE" ]; then
        echo "[ERROR] Configuration not found at $SOURCE"
        echo "Run 'just install' first to install the configuration"
        exit 1
    fi

    echo "Pulling configuration from ~/.claude to repository..."
    echo "====================================================="
    echo ""

    # Show what will be synced
    echo "Checking for changes..."
    CHANGES=$(rsync -avn --delete \
        --exclude='*.pyc' \
        --exclude='.DS_Store' \
        --exclude='.claude/settings.local.json' \
        --exclude='.credentials.json' \
        --exclude='.git' \
        --exclude='.update_check' \
        --exclude='Justfile' \
        --exclude='README.md' \
        --exclude='__pycache__' \
        --exclude='backups/*' \
        --exclude='debug/*' \
        --exclude='file-history/*' \
        --exclude='history.jsonl' \
        --exclude='local/*' \
        --exclude='plugins/cache/*' \
        --exclude='projects/*' \
        --exclude='session-env/*' \
        --exclude='shell-snapshots/*' \
        --exclude='statsig/*' \
        --exclude='todos/*' \
        "$SOURCE/" "$TARGET/" | grep -v '/$' || true)

    if [ -z "$CHANGES" ]; then
        echo "No changes to sync"
        exit 0
    fi

    echo "The following files will be synced:"
    echo "$CHANGES"
    echo ""

    # Perform the sync
    rsync -av --delete \
        --exclude='*.pyc' \
        --exclude='.DS_Store' \
        --exclude='.claude/settings.local.json' \
        --exclude='.credentials.json' \
        --exclude='.git' \
        --exclude='.update_check' \
        --exclude='Justfile' \
        --exclude='README.md' \
        --exclude='__pycache__' \
        --exclude='backups/*' \
        --exclude='debug/*' \
        --exclude='file-history/*' \
        --exclude='history.jsonl' \
        --exclude='local/*' \
        --exclude='plugins/cache/*' \
        --exclude='projects/*' \
        --exclude='session-env/*' \
        --exclude='shell-snapshots/*' \
        --exclude='statsig/*' \
        --exclude='todos/*' \
        "$SOURCE/" "$TARGET/"

    echo ""
    echo "[SUCCESS] Configuration pulled from ~/.claude to repository"
    echo ""
    echo "Changes are now in your working directory."
    echo "Review with 'git status' and commit if desired."
