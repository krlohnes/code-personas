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

# Use local state if .claude exists locally, otherwise global
if [ -d ".claude" ]; then
    STATE_FILE=".claude/state/current-persona"
else
    STATE_FILE="$HOME/.claude/state/current-persona"
fi

# Function to list all personas (local and global, with indicators)
list_personas() {
    echo "Available personas:"
    
    # Track seen personas to avoid duplicates
    declare -A seen_personas
    
    # List local personas first
    if [ -d ".claude/personas" ]; then
        for file in .claude/personas/*.md; do
            if [ -f "$file" ]; then
                name=$(basename "$file" .md)
                echo "  - $name [local]"
                seen_personas["$name"]=1
            fi
        done
    fi
    
    # List global personas (skip if already seen)
    if [ -d "$HOME/.claude/personas" ]; then
        for file in "$HOME/.claude/personas"/*.md; do
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
        # Find persona file (local first, then global)
        if [ -f ".claude/personas/$1.md" ]; then
            persona_file=".claude/personas/$1.md"
            location="[local]"
        elif [ -f "$HOME/.claude/personas/$1.md" ]; then
            persona_file="$HOME/.claude/personas/$1.md" 
            location="[global]"
        else
            echo "Persona '$1' not found. Use '/persona list' to see available personas."
            exit 1
        fi
        
        mkdir -p "$(dirname "$STATE_FILE")"
        echo "$1" > "$STATE_FILE"
        echo "Switched to persona: $1 $location"
        ;;
esac
```