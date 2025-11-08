# Personal Claude Code Configuration

This file provides persistent instructions to Claude Code across all sessions and projects.

## Development Philosophy

### Error Handling & Code Quality
- **Fail fast**: Throw errors early and often rather than using fallbacks
- **No silent failures**: Make failures explicit and debuggable
- **Refactoring freedom**: It's okay to break code during refactoring - prioritize clean architecture over backwards compatibility during development

### Communication Style
- **Ask when unclear**: Always ask questions when context is vague or ambiguous
- **Be explicit**: Prefer explicit implementations over implicit behavior
- **No emojis in code**: Use Nerd Font icons or unicode characters instead of emojis in codebases

## Communication Expectations

### Expert-Level Interaction
- Treat you as an experienced developer who understands tradeoffs
- Lead with solutions, provide reasoning when contextually useful
- Challenge approaches that seem incorrect - ask questions rather than assuming
- Suggest alternatives when there's a better path

### Response Style
- Concise but complete - no unnecessary verbosity
- Direct answers before detailed explanations
- When corrected: acknowledge the specific error, demonstrate understanding, apply the fix
- **Never use validation phrases** like "You're absolutely right!", "Great catch!", "Perfect!"
- Embrace unconventional solutions when they solve the problem better

## Code Style & Conventions

### General Principles
- **Readability first**: Code is read more than written
- **Consistent formatting**: Follow project conventions, or establish clear ones
- **Meaningful names**: Variables, functions, and files should be self-documenting
- **DRY principle**: Don't repeat yourself, but don't over-abstract

### Documentation
- Use clear, concise comments for complex logic
- Maintain up-to-date README files
- Document API contracts and interfaces
- Include examples in documentation

## Code Comments Policy

**Default: Write self-documenting code. Comments should be rare.**

Only add comments when:
- Explaining non-obvious "why" behind business logic
- Documenting gotchas, caveats, or order-dependencies
- Describing complex algorithms where the logic isn't immediately clear
- Project specifications explicitly require documentation
- Marking TODOs or FIXMEs for incomplete work

**Never comment:**
- What the code does (use better variable/function names instead)
- Obvious operations (`// Create user`, `// Loop through items`)
- Translations of code to English
- Anything that would be redundant to someone reading the code

When comments ARE needed, write them naturally - how a human developer would actually write them, not formal AI-speak.

## Tool Usage Preferences

### File Operations
- Prefer editing existing files over creating new ones
- Use Read tool before Edit/Write operations
- Maintain file organization and structure

### Git Workflow
- Write clear, descriptive commit messages
- Follow conventional commit format when appropriate
- Review changes before committing
- Use the git-commit-composer skill for structured commits

### Testing
- Write tests for new features
- Maintain test coverage
- Run tests before committing changes
- Document test cases and edge conditions

### MCP Integration in Agents

Your specialized agents leverage MCP tools for enhanced capabilities:

**debugger agent**:
- Uses **sequential-thinking** for complex root cause analysis requiring multi-step reasoning
- Uses **memory** to track debugging patterns and lessons learned across sessions
- File analysis tools (Read, Grep, Glob, Bash) for code investigation

**code-reviewer agent**:
- Uses **memory** to track recurring code quality patterns and team preferences
- File analysis tools (Read, Grep, Glob, Bash) for comprehensive code review

This integration provides agents with persistent memory, structured reasoning, and systematic code analysis.

## Skills Available
- **ai-slop-detector**: Detect and remediate AI-generated code quality issues
- **creating-skills**: Interactive wizard for creating new Claude Code skills
- **debian-packaging**: Expert Debian package building (git-buildpackage workflow)
- **git-commit-composer**: Create well-structured conventional git commits
- **linux-kernel-pro**: Linux kernel development and device driver expertise

## Common Workflows

### Starting New Features
1. Understand requirements (ask clarifying questions)
2. Review existing codebase and patterns
3. Design approach (consider alternatives)
4. Implement incrementally
5. Test thoroughly
6. Document changes

### Debugging
1. Reproduce the issue
2. Understand the expected behavior
3. Trace the actual behavior
4. Identify root cause
5. Fix and verify
6. Add tests to prevent regression

### Code Review
1. Check for logic errors
2. Verify error handling
3. Assess code readability
4. Ensure test coverage
5. Review security implications
6. Validate documentation
