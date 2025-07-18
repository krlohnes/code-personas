# Persona Management Command

This command manages Claude's behavior personas by switching between predefined personality and instruction sets.

## Usage

```
/persona [persona-name]
/persona list
/persona clear
```

## Commands

- `/persona [name]` - Switch to a specific persona
- `/persona list` - List all available personas  
- `/persona clear` - Clear current persona and return to default behavior

## Available Personas

The system looks for persona files in:
- `.claude/personas/[name].md` (project-specific, takes precedence)
- `~/.claude/personas/[name].md` (global)

## Examples

```
/persona dev
/persona reviewer
/persona clear
```

---

# Implementation

```bash
#!/bin/bash

# Define directories (project-specific takes precedence)
LOCAL_PERSONAS_DIR=".claude/personas"
GLOBAL_PERSONAS_DIR="$HOME/.claude/personas"
LOCAL_STATE_FILE=".claude/state/current-persona"
GLOBAL_STATE_FILE="$HOME/.claude/state/current-persona"

# Use local state if .claude exists locally, otherwise global
if [ -d ".claude" ]; then
    STATE_FILE="$LOCAL_STATE_FILE"
else
    STATE_FILE="$GLOBAL_STATE_FILE"
fi

# Function to find persona file (local first, then global)
find_persona() {
    local name="$1"
    if [ -f "$LOCAL_PERSONAS_DIR/$name.md" ]; then
        echo "$LOCAL_PERSONAS_DIR/$name.md"
    elif [ -f "$GLOBAL_PERSONAS_DIR/$name.md" ]; then
        echo "$GLOBAL_PERSONAS_DIR/$name.md"
    else
        echo ""
    fi
}

# Function to list all personas (local and global, with indicators)
list_personas() {
    echo "Available personas:"
    
    # Track seen personas to avoid duplicates
    declare -A seen_personas
    
    # List local personas first (with [local] indicator)
    if [ -d "$LOCAL_PERSONAS_DIR" ]; then
        for file in "$LOCAL_PERSONAS_DIR"/*.md; do
            if [ -f "$file" ]; then
                name=$(basename "$file" .md)
                echo "  - $name [local]"
                seen_personas["$name"]=1
            fi
        done
    fi
    
    # List global personas (with [global] indicator, skip if already seen)
    if [ -d "$GLOBAL_PERSONAS_DIR" ]; then
        for file in "$GLOBAL_PERSONAS_DIR"/*.md; do
            if [ -f "$file" ]; then
                name=$(basename "$file" .md)
                if [ -z "${seen_personas[$name]}" ]; then
                    echo "  - $name [global]"
                fi
            fi
        done
    fi
    
    # If no personas found
    if [ ${#seen_personas[@]} -eq 0 ]; then
        echo "  No personas found"
    fi
}

case "$1" in
    "list")
        list_personas
        ;;
    "clear")
        rm -f "$STATE_FILE"
        echo "Cleared current persona"
        ;;
    "")
        if [ -f "$STATE_FILE" ]; then
            current=$(cat "$STATE_FILE")
            echo "Current persona: $current"
        else
            echo "No active persona"
        fi
        ;;
    *)
        persona_file=$(find_persona "$1")
        if [ -n "$persona_file" ]; then
            mkdir -p "$(dirname "$STATE_FILE")"
            echo "$1" > "$STATE_FILE"
            if [[ "$persona_file" == "$LOCAL_PERSONAS_DIR"* ]]; then
                echo "Switched to persona: $1 [local]"
            else
                echo "Switched to persona: $1 [global]"
            fi
        else
            echo "Persona '$1' not found. Use '/persona list' to see available personas."
            exit 1
        fi
        ;;
esac
```