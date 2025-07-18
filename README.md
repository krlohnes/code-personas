# Claude Code Personas

A persona management system for Claude Code that allows you to switch between different behavioral modes and instruction sets.

## Features

- **Persona Switching**: Use `/persona [name]` to switch Claude's behavior
- **Automatic Injection**: Personas are automatically applied to all user interactions
- **Custom Personas**: Create your own persona files with specific instructions
- **State Management**: Tracks the currently active persona across sessions

## Installation

### Option 1: Global Installation (Recommended)

1. **Clone and install**:
   ```bash
   # Clone this repo
   git clone https://github.com/your-username/code-personas.git
   cd code-personas
   
   # Run the installer
   ./install.sh
   ```

   The installer will:
   - Copy all persona files to `~/.claude/`
   - Set proper executable permissions
   - Update your `settings.json` with hook configuration
   - Create backups of existing settings

### Option 2: Manual Installation

1. **Copy the system to your global Claude directory**:
   ```bash
   # Copy to global Claude directory
   cp -r .claude/* ~/.claude/
   ```

2. **Configure Claude Code** by adding to your global settings file:
   ```json
   {
     "hooks": {
       "UserPromptSubmit": [
         {
           "hooks": [
             {
               "type": "command",
               "command": "/Users/your-username/.claude/hooks/user-prompt-submit"
             }
           ]
         }
       ]
     }
   }
   ```
   
   **Replace `/Users/your-username/` with your actual home directory path**
   
   **Settings file location:**
   - macOS: `~/.claude/settings.json`
   - Linux: `~/.claude/settings.json` 
   - Windows: `%USERPROFILE%\.claude\settings.json`

### Option 2: Per-Project Installation

1. **Clone or copy the `.claude/` directory** to your project root
2. **Configure Claude Code** to use the local hook in your project's settings:
   ```json
   {
     "hooks": {
       "UserPromptSubmit": [
         {
           "hooks": [
             {
               "type": "command", 
               "command": "./.claude/hooks/user-prompt-submit"
             }
           ]
         }
       ]
     }
   }
   ```

### Hybrid Approach (Best of Both)
You can combine both approaches:
- Install globally for baseline personas available everywhere
- Add project-specific personas that override or extend global ones
- Local personas take precedence when both exist

### Benefits of Global Installation
- Works across all projects automatically
- Personas available everywhere you use Claude Code
- Single location to manage and customize personas
- No need to copy files to each project

### Persona Resolution
The system searches for personas in this order:
1. **Local first**: `.claude/personas/[name].md` (project-specific)
2. **Global fallback**: `~/.claude/personas/[name].md` (global)

When listing personas with `/persona list`, you'll see:
- `dev [local]` - project-specific override
- `reviewer [global]` - global persona

## Quick Start

1. **List available personas**:
   ```
   /persona list
   ```

2. **Switch to a persona**:
   ```
   /persona dev
   /persona reviewer
   /persona hippie
   /persona boston
   ```

3. **Clear current persona**:
   ```
   /persona clear
   ```

4. **Check current persona**:
   ```
   /persona current
   ```
   
   Or just:
   ```
   /persona
   ```

## Built-in Personas

### `dev` - Developer Mode
- Focuses on code quality and best practices
- Emphasizes security and performance
- Provides technical implementation details
- Suggests refactoring opportunities

### `reviewer` - Code Review Mode
- Thorough code analysis and feedback
- Checks for bugs, security issues, and performance problems
- Provides constructive, actionable suggestions
- Focuses on maintainability and standards compliance

### `hippie` - Cosmic Code Philosopher
- Totally groovy 60s hippie amazed by computer magic
- Calls programmers "lightning rock wizards"
- Provides zero practical advice but maximum cosmic vibes
- Philosophizes about the spiritual meaning of code

### `boston` - Southie Code Master
- Wicked smaht Boston programmer with thick accent
- World-class coding skills but talks like he's from the depahted
- Swears like a sailor but occasionally apologizes for it
- Calls you "kid", "boss", "chief", "guy", "buddy", "pal"

## Creating Custom Personas

1. Create a new markdown file in `.claude/personas/[name].md`
2. Define the persona's behavior, communication style, and priorities
3. Use `/persona [name]` to activate it

Example persona structure:
```markdown
# My Custom Persona

## Core Principles
- Define key principles here

## Communication Style
- Describe preferred tone and approach

## Priorities
1. Primary focus
2. Secondary focus
```

## Architecture

```
.claude/
├── commands/
│   └── persona.md          # /persona slash command implementation
├── hooks/
│   └── user-prompt-submit  # Hook that injects persona into prompts
├── personas/
│   ├── dev.md             # Developer persona
│   ├── reviewer.md        # Code reviewer persona
│   └── user-persona-1.md  # Template for custom personas
└── state/
    └── current-persona    # Tracks active persona
```

## How It Works

1. **Slash Command**: `/persona` command manages persona switching and stores state
2. **Hook Integration**: `user-prompt-submit` hook automatically injects active persona instructions
3. **State Persistence**: Current persona is stored in `.claude/state/current-persona`
4. **Automatic Application**: Every user message gets prepended with persona instructions

## Example Usage

```bash
# Switch to developer mode
/persona dev

# Now all interactions will use developer persona
"Add error handling to this function"
# Claude responds with focus on robust error handling,
# testing, and code quality

# Switch to reviewer mode
/persona reviewer

# Now Claude acts as a code reviewer
"Review this pull request"
# Claude provides thorough code review with specific feedback

# Switch to Boston coder mode
/persona boston

# Now Claude codes with a wicked Boston accent
"Help me optimize this algorithm"
# Claude responds: "Listen boss, that algorithm's slower than the fuckin' Green Line..."

# Return to default behavior
/persona clear
```
