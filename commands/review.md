---
description: Perform a comprehensive code review checklist
argument-hint: "[files or scope]"
allowed-tools: Read, Grep, Glob
---

# Code Review Checklist

Perform a thorough code review of the specified files or current changes.

## Scope

$ARGUMENTS

## Review Checklist

Systematically check the following:

### 1. Functionality
- [ ] Code does what it's supposed to do
- [ ] Edge cases are handled
- [ ] No logic errors

### 2. Code Quality
- [ ] Follows project conventions and style guide
- [ ] Code is readable and well-organized
- [ ] No code duplication (DRY principle)
- [ ] Functions/methods have single responsibility
- [ ] Meaningful variable and function names

### 3. Error Handling
- [ ] Errors are caught and handled appropriately
- [ ] Error messages are clear and helpful
- [ ] No silent failures
- [ ] Resources are properly cleaned up

### 4. Security
- [ ] No SQL injection vulnerabilities
- [ ] No XSS vulnerabilities
- [ ] No command injection risks
- [ ] Sensitive data is not exposed
- [ ] Input validation is present
- [ ] Authentication/authorization is correct

### 5. Performance
- [ ] No obvious performance bottlenecks
- [ ] Appropriate data structures used
- [ ] No unnecessary operations in loops
- [ ] Database queries are optimized

### 6. Testing
- [ ] Tests exist for new functionality
- [ ] Tests cover edge cases
- [ ] Tests are readable and maintainable
- [ ] Test coverage is adequate

### 7. Documentation
- [ ] Complex logic is commented
- [ ] API changes are documented
- [ ] README is updated if needed
- [ ] Inline comments explain "why" not "what"

### 8. Dependencies
- [ ] New dependencies are justified
- [ ] Dependencies are up to date
- [ ] No security vulnerabilities in dependencies

## Instructions

Analyze the code and provide feedback for each relevant section above.
