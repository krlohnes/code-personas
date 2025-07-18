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