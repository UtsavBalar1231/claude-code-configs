---
description: Guided refactoring workflow with safety checks
argument-hint: "[description of refactoring]"
allowed-tools: Read, Edit, Write, Grep, Glob, Bash(git *)
---

# Refactoring Workflow

Perform safe, systematic refactoring following best practices.

## Refactoring Goal

$ARGUMENTS

## Refactoring Principles

Remember these key principles:
- **It's okay to break code during refactoring**
- Make incremental changes
- Keep tests passing (or update them appropriately)
- Improve design without changing behavior
- Document significant architectural changes

## Systematic Approach

### 1. Understand Current State
- [ ] Read and understand existing code
- [ ] Identify code smells or improvement opportunities
- [ ] Check test coverage for areas being refactored

### 2. Plan Refactoring
- [ ] Define clear refactoring goal
- [ ] Identify all affected components
- [ ] Plan incremental steps
- [ ] Consider backwards compatibility (if needed)

### 3. Execute Refactoring
- [ ] Make one change at a time
- [ ] Run tests after each change
- [ ] Fix/update tests as needed
- [ ] Commit working states incrementally

### 4. Verify Results
- [ ] All tests pass
- [ ] No regression in functionality
- [ ] Code quality improved
- [ ] Performance not degraded

## Common Refactoring Patterns

### Extract Method/Function
- Take complex code block
- Extract to named function
- Replace with function call

### Rename for Clarity
- Identify unclear names
- Choose descriptive names
- Update all references

### Simplify Conditionals
- Replace nested ifs with guard clauses
- Extract complex conditions to named variables
- Use polymorphism instead of type checks

### Remove Duplication
- Identify repeated code
- Extract to shared function/module
- Maintain single source of truth

### Improve Structure
- Move code to appropriate modules
- Separate concerns
- Follow SOLID principles

## Safety Notes

- Always have tests before major refactoring
- Commit working state frequently
- Don't mix refactoring with new features
- Use version control for easy rollback
