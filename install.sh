#!/bin/bash

# Claude Code Personas - Global Installation Script
# This script installs the personas system globally for Claude Code

set -e  # Exit on any error

CLAUDE_DIR="$HOME/.claude"
SETTINGS_FILE="$CLAUDE_DIR/settings.json"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "🎭 Installing Claude Code Personas globally..."

# Check if jq is available
if ! command -v jq &> /dev/null; then
    echo "❌ Error: jq is required but not installed."
    echo "   Install with: brew install jq (macOS) or apt-get install jq (Linux)"
    exit 1
fi

# Create Claude directory if it doesn't exist
if [ ! -d "$CLAUDE_DIR" ]; then
    echo "📁 Creating Claude directory: $CLAUDE_DIR"
    mkdir -p "$CLAUDE_DIR"
fi

# Copy personas system files
echo "📂 Copying personas system files..."
cp -r "$SCRIPT_DIR/.claude/"* "$CLAUDE_DIR/"

# Make executables
chmod +x "$CLAUDE_DIR/hooks/user-prompt-submit"
chmod +x "$CLAUDE_DIR/commands/persona"
echo "🔧 Made hook and command executable"

# Handle settings.json
if [ ! -f "$SETTINGS_FILE" ]; then
    echo "📝 Creating new settings.json..."
    cat > "$SETTINGS_FILE" << 'EOF'
{
  "hooks": {
    "UserPromptSubmit": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "~/.claude/hooks/user-prompt-submit"
          }
        ]
      }
    ]
  }
}
EOF
else
    echo "⚙️  Updating existing settings.json..."
    
    # Create backup
    cp "$SETTINGS_FILE" "$SETTINGS_FILE.backup"
    echo "💾 Backed up settings to $SETTINGS_FILE.backup"
    
    # Get absolute path to hook
    HOOK_PATH="$CLAUDE_DIR/hooks/user-prompt-submit"
    
    # Update settings with jq
    jq --arg hook_path "$HOOK_PATH" '
        .hooks.UserPromptSubmit = [
            {
                "hooks": [
                    {
                        "type": "command",
                        "command": $hook_path
                    }
                ]
            }
        ]
    ' "$SETTINGS_FILE" > "$SETTINGS_FILE.tmp" && mv "$SETTINGS_FILE.tmp" "$SETTINGS_FILE"
fi

echo ""
echo "✅ Installation complete!"
echo ""
echo "Available personas:"
ls -1 "$CLAUDE_DIR/personas/" | sed 's/\.md$//' | sed 's/^/  - /'
echo ""
echo "Quick start:"
echo "  /persona list      # List available personas"
echo "  /persona dev       # Switch to developer mode"
echo "  /persona hippie    # Switch to cosmic philosopher mode"
echo "  /persona clear     # Clear current persona"
echo ""
echo "Add custom personas by creating files in:"
echo "  $CLAUDE_DIR/personas/your-persona-name.md"