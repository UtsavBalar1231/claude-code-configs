---
description: Run test suite with coverage and reporting
argument-hint: "[test pattern or scope]"
allowed-tools: Read, Bash, Grep, Glob
---

# Run Tests

Execute the project's test suite with appropriate options.

## Test Scope

$ARGUMENTS

## Instructions

1. **Detect the testing framework** used in the project:
   - Python: pytest, unittest, nose
   - JavaScript/TypeScript: jest, mocha, vitest
   - Go: go test
   - Rust: cargo test
   - Other: check package.json, Makefile, or project docs

2. **Run tests with coverage** if available:
   - Python: `pytest --cov --cov-report=term-missing`
   - JS: `npm test -- --coverage` or `jest --coverage`
   - Go: `go test -cover ./...`
   - Rust: `cargo test`

3. **Report results**:
   - Show pass/fail status
   - Display coverage percentage
   - Highlight any failures with details
   - Suggest fixes if tests fail

4. **Additional checks** (if applicable):
   - Run linter after tests
   - Check for type errors (TypeScript, mypy, etc.)
   - Run security checks if configured

## Quick Commands

If you find common test commands, suggest aliases or document them here for future reference.
