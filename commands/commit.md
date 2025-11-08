---
description: Create a well-structured git commit using conventional commit format
argument-hint: "[message]"
allowed-tools: Bash(git *), Read, Grep
---

# Git Commit Workflow

Create a well-structured git commit following best practices.

## Instructions

1. **Use the git-commit-composer skill** to analyze changes and create a proper commit
2. If the user provided a message in `$ARGUMENTS`, use it as guidance
3. Otherwise, analyze the staged/unstaged changes to draft an appropriate message

## Process

- Review git status to see what will be committed
- Analyze the diff to understand the changes
- Create a conventional commit message:
  - Format: `type(scope): subject`
  - Types: feat, fix, docs, style, refactor, test, chore
  - Keep subject under 50 characters
  - Add body if needed (wrap at 72 characters)
- Stage appropriate files if not already staged
- Create the commit
- Verify with git log

## User Message

$ARGUMENTS
