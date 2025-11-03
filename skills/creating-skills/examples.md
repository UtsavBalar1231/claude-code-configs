# Skill Examples

Real-world examples of well-structured Claude Code skills across different use cases.

## Example 1: Simple Single-File Skill

### commit-message-generator

**Use case:** Generate consistent commit messages following team conventions

```markdown
---
name: commit-message-generator
description: Generate clear, conventional commit messages from git diffs. Use when writing commit messages, reviewing staged changes, or asking about git commits.
---

# Commit Message Generator

## Quick Start

I'll analyze your staged changes and suggest a commit message following conventional commits format.

## Instructions

1. Run `git diff --staged` to see what's being committed
2. Analyze the changes and determine:
   - Type: feat, fix, docs, style, refactor, test, chore
   - Scope: affected component or module
   - Summary: what changed (present tense, imperative mood)
   - Body: why it changed (if not obvious)
3. Format as:
   ```
   type(scope): summary under 50 chars

   Detailed explanation if needed.
   Include motivation and context.

   Breaking changes or important notes.
   ```

## Examples

**Good commit messages:**
```
feat(auth): add OAuth2 login flow

Implements Google and GitHub authentication.
Users can now sign in using social accounts.

Closes #123
```

```
fix(api): handle null response in user endpoint

The /api/users endpoint crashed when user data was null.
Now returns 404 with appropriate error message.
```

**Bad commit messages:**
```
update stuff
fixed bug
WIP
```

## Best Practices

- Summary under 50 characters
- Use present tense ("add" not "added")
- Explain what AND why, not how
- Reference issue numbers
- Group related changes
```

**Why this works:**
- Clear trigger words: "commit", "git", "staged changes"
- Single focused purpose
- Concrete examples showing good vs bad
- Step-by-step instructions

---

## Example 2: Skill with Tool Restrictions

### code-reviewer

**Use case:** Review code for quality, security, and best practices (read-only)

```markdown
---
name: code-reviewer
description: Review code for quality, security, performance, and best practices. Use when reviewing code, checking pull requests, analyzing code quality, or conducting code audits. Read-only analysis.
allowed-tools: Read, Grep, Glob
---

# Code Reviewer

## Quick Start

I'll analyze your code and provide detailed feedback on:
- Code organization and structure
- Security vulnerabilities
- Performance issues
- Best practice violations
- Test coverage

## Instructions

### Phase 1: Discovery
1. Use Glob to find relevant files based on file patterns
2. Use Grep to search for specific patterns or anti-patterns
3. Use Read to examine identified files

### Phase 2: Analysis
Evaluate each file for:

**Code Quality:**
- Naming conventions
- Function complexity (cyclomatic complexity)
- Code duplication
- Dead code

**Security:**
- Input validation
- Authentication/authorization
- Secret management
- SQL injection risks
- XSS vulnerabilities

**Performance:**
- N+1 queries
- Unnecessary loops
- Memory leaks
- Inefficient algorithms

**Best Practices:**
- Error handling
- Logging
- Documentation
- Type safety

### Phase 3: Report
Provide structured feedback:
```markdown
## Code Review Summary

### Critical Issues (must fix)
- [Issue description] at [file:line]

### Important Issues (should fix)
- [Issue description] at [file:line]

### Suggestions (nice to have)
- [Issue description] at [file:line]

### Positive Observations
- [What's done well]
```

## Examples

**Security issue identified:**
```python
# BAD: SQL injection vulnerability
query = f"SELECT * FROM users WHERE id = {user_id}"

# GOOD: Parameterized query
query = "SELECT * FROM users WHERE id = %s"
cursor.execute(query, (user_id,))
```

**Performance issue identified:**
```python
# BAD: N+1 query problem
for user in users:
    user.orders = db.query(Order).filter(Order.user_id == user.id).all()

# GOOD: Eager loading
users = db.query(User).options(joinedload(User.orders)).all()
```

## Best Practices

- Focus on actionable feedback
- Provide specific file:line references
- Explain WHY something is an issue
- Suggest concrete fixes
- Balance criticism with positive observations
- Prioritize by severity
```

**Why this works:**
- `allowed-tools` restricts to read-only operations
- Structured phases prevent chaotic analysis
- Concrete examples of issues and fixes
- Clear trigger words: "review", "code quality", "pull request"

---

## Example 3: Multi-File Skill with Scripts

### api-documentation

**Use case:** Generate API documentation from code with validation scripts

```
api-documentation/
├── SKILL.md
├── REFERENCE.md
└── scripts/
    ├── extract_endpoints.py
    └── validate_openapi.py
```

**SKILL.md:**
```markdown
---
name: api-documentation
description: Generate API documentation from source code, validate OpenAPI specs, and create developer guides. Use when documenting APIs, creating OpenAPI/Swagger specs, or writing API guides.
---

# API Documentation

## Quick Start

I'll analyze your API code and generate comprehensive documentation including endpoints, request/response formats, authentication, and examples.

## Instructions

### 1. Discover API Endpoints

Use the extraction script:
```bash
python scripts/extract_endpoints.py --path ./src --framework flask
```

This identifies:
- Endpoints (path, method)
- Request parameters
- Response schemas
- Authentication requirements

### 2. Generate Documentation

Create documentation in format you prefer:
- OpenAPI/Swagger JSON
- Markdown developer guide
- Postman collection
- README API section

### 3. Validate

Run validation:
```bash
python scripts/validate_openapi.py openapi.json
```

Checks for:
- Schema compliance
- Missing required fields
- Example validity
- Reference integrity

## Documentation Structure

```markdown
# API Documentation

## Authentication
[Auth methods, token format, headers]

## Base URL
[Production and staging URLs]

## Endpoints

### GET /api/users
[Description]

**Parameters:**
- `page` (integer, optional): Page number
- `limit` (integer, optional): Items per page

**Response:**
```json
{
  "users": [...],
  "total": 100,
  "page": 1
}
```

**Errors:**
- 401: Unauthorized
- 404: Not found
```

For detailed schema reference, see [REFERENCE.md](REFERENCE.md).

## Examples

**Flask endpoint documentation:**
```python
@app.route('/api/users/<int:user_id>', methods=['GET'])
@require_auth
def get_user(user_id):
    """Get user by ID.

    Args:
        user_id: Integer user identifier

    Returns:
        JSON user object or 404
    """
    ...
```

Generates:
```markdown
### GET /api/users/{user_id}

Get user by ID. Requires authentication.

**Path Parameters:**
- `user_id` (integer, required): User identifier

**Response 200:**
```json
{
  "id": 123,
  "name": "John Doe",
  "email": "john@example.com"
}
```

**Response 404:**
```json
{
  "error": "User not found"
}
```
```

## Best Practices

- Document all endpoints
- Include request/response examples
- Show error responses
- Document authentication
- Keep examples up to date
- Validate generated specs
- Include rate limiting info
```

**REFERENCE.md:**
```markdown
# API Schema Reference

## User Object
```json
{
  "id": "integer",
  "name": "string",
  "email": "string (email format)",
  "created_at": "string (ISO 8601)",
  "role": "enum [admin, user, guest]"
}
```

## Error Object
```json
{
  "error": "string",
  "code": "string",
  "details": "object (optional)"
}
```

[Additional schema definitions...]
```

**scripts/extract_endpoints.py:**
```python
#!/usr/bin/env python3
"""Extract API endpoints from source code."""

import ast
import argparse
from pathlib import Path

def extract_flask_endpoints(file_path):
    """Parse Flask routes from Python file."""
    # Implementation here
    pass

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--path', required=True)
    parser.add_argument('--framework', choices=['flask', 'fastapi', 'django'])
    args = parser.parse_args()

    # Extract and print endpoints
    endpoints = extract_endpoints(args.path, args.framework)
    print(json.dumps(endpoints, indent=2))

if __name__ == '__main__':
    main()
```

**Why this works:**
- Progressive disclosure: SKILL.md → REFERENCE.md
- Executable scripts for deterministic tasks
- Clear separation: instructions vs reference vs code
- Comprehensive trigger words: "API", "documentation", "OpenAPI", "Swagger"

---

## Example 4: Domain-Specific Skill

### financial-report-analyzer

**Use case:** Analyze financial reports using specific accounting frameworks

```markdown
---
name: financial-report-analyzer
description: Analyze financial statements, calculate financial ratios, and generate insights using GAAP/IFRS standards. Use when analyzing balance sheets, income statements, cash flow statements, or calculating financial metrics.
---

# Financial Report Analyzer

## Quick Start

I'll analyze financial statements and calculate key metrics following accounting standards.

## Instructions

### 1. Identify Statement Type

Determine what you're analyzing:
- Balance Sheet (assets, liabilities, equity)
- Income Statement (revenue, expenses, profit)
- Cash Flow Statement (operating, investing, financing)
- Combined analysis

### 2. Calculate Key Ratios

**Liquidity Ratios:**
```
Current Ratio = Current Assets / Current Liabilities
Quick Ratio = (Current Assets - Inventory) / Current Liabilities
```

**Profitability Ratios:**
```
Gross Profit Margin = (Revenue - COGS) / Revenue
Net Profit Margin = Net Income / Revenue
ROE = Net Income / Shareholders' Equity
ROA = Net Income / Total Assets
```

**Leverage Ratios:**
```
Debt-to-Equity = Total Debt / Total Equity
Interest Coverage = EBIT / Interest Expense
```

**Efficiency Ratios:**
```
Asset Turnover = Revenue / Average Total Assets
Inventory Turnover = COGS / Average Inventory
```

### 3. Analyze Trends

Compare metrics across:
- Multiple periods (YoY, QoQ)
- Industry benchmarks
- Competitor performance

### 4. Generate Insights

Provide:
- Strengths and weaknesses
- Red flags or concerns
- Growth trajectory
- Risk assessment
- Recommendations

## Examples

**Input: Balance Sheet Data**
```
Assets: $1,000,000
Current Assets: $400,000
Inventory: $100,000
Liabilities: $600,000
Current Liabilities: $200,000
Equity: $400,000
```

**Analysis:**
```markdown
### Liquidity Analysis

**Current Ratio:** 2.0 (400,000 / 200,000)
- Interpretation: Strong liquidity. Company can cover short-term obligations 2x over.
- Benchmark: Healthy (>1.5 is generally good)

**Quick Ratio:** 1.5 ((400,000 - 100,000) / 200,000)
- Interpretation: Even excluding inventory, strong liquidity position.
- Benchmark: Excellent (>1.0 is healthy)

### Leverage Analysis

**Debt-to-Equity:** 1.5 (600,000 / 400,000)
- Interpretation: Moderate leverage. $1.50 debt per $1 equity.
- Benchmark: Acceptable for most industries, but review interest coverage.

### Overall Assessment

✓ Strong liquidity position
✓ Adequate working capital
⚠ Monitor debt levels and ensure sufficient cash flow for interest payments
```

## Best Practices

- Always specify which accounting standard (GAAP/IFRS)
- Calculate multiple ratios for complete picture
- Compare against industry standards
- Look for trends over time
- Consider qualitative factors (industry conditions, management)
- Note any unusual items or one-time events
- State assumptions clearly

## Common Pitfalls

- Using outdated data
- Ignoring seasonality
- Comparing across different industries
- Relying on single metrics
- Not considering off-balance-sheet items
```

**Why this works:**
- Domain-specific terminology triggers activation
- Formulas provide deterministic calculations
- Structured analysis framework ensures consistency
- Real examples show expected output format

---

## Example 5: Team Workflow Skill (Project Skill)

### code-review-checklist

**Use case:** Team-specific code review process (goes in `.claude/skills/`)

```markdown
---
name: code-review-checklist
description: Apply team-specific code review checklist and standards. Use when reviewing pull requests, conducting code reviews, or checking code before merge.
---

# Code Review Checklist

Team-specific code review process for [Your Team Name].

## Quick Start

I'll review code against our team's standards and checklist.

## Review Process

### 1. Pre-Review Checks

Before detailed review:
- [ ] PR description clearly explains what and why
- [ ] All CI checks passing
- [ ] No merge conflicts
- [ ] Appropriate reviewers assigned
- [ ] Linked to relevant ticket/issue

### 2. Code Quality Review

**Naming Conventions (Team Standard):**
- Functions: `snake_case` (Python) or `camelCase` (JavaScript)
- Classes: `PascalCase`
- Constants: `UPPER_SNAKE_CASE`
- Private methods: prefix with `_` (Python) or `#` (JavaScript)

**File Organization:**
```
src/
  features/
    feature_name/
      __init__.py
      models.py      # Data models
      services.py    # Business logic
      views.py       # API endpoints
      tests/         # Feature tests
```

**Documentation Requirements:**
- [ ] Public functions have docstrings
- [ ] Complex logic has inline comments
- [ ] README updated if needed
- [ ] API changes documented

### 3. Testing Requirements

**Minimum Coverage:**
- Unit tests: 80% coverage
- Integration tests for API endpoints
- Edge cases covered

**Test Structure:**
```python
def test_function_name_scenario_expected_outcome():
    """Test that function_name handles scenario correctly."""
    # Arrange
    input_data = ...
    expected = ...

    # Act
    result = function_name(input_data)

    # Assert
    assert result == expected
```

### 4. Security Review

**Team Security Checklist:**
- [ ] No secrets in code (use environment variables)
- [ ] Input validation on all user inputs
- [ ] SQL queries use parameterization
- [ ] Authentication/authorization checks present
- [ ] Error messages don't leak sensitive info
- [ ] Dependencies up to date (no known vulnerabilities)

### 5. Performance Considerations

**Team Guidelines:**
- Database queries: Use indexes, avoid N+1
- API endpoints: Response time <200ms target
- Large datasets: Implement pagination
- Expensive operations: Use caching

### 6. Team-Specific Requirements

**Logging:**
```python
# Use team logger
from shared.logging import get_logger
logger = get_logger(__name__)

# Log levels
logger.debug("Detailed info for debugging")
logger.info("General information")
logger.warning("Warning about potential issues")
logger.error("Error that needs attention")
```

**Error Handling:**
```python
# Team standard error responses
from shared.errors import ValidationError, NotFoundError

def get_user(user_id):
    if not validate_id(user_id):
        raise ValidationError("Invalid user ID format")

    user = db.get(user_id)
    if not user:
        raise NotFoundError(f"User {user_id} not found")

    return user
```

### 7. Review Completion

**Approval Criteria:**
- All checklist items passed
- No unresolved comments
- Changes align with architecture
- No degradation in test coverage
- Performance impact acceptable

**Review Comments Format:**
```markdown
**[BLOCKING]** Issue that must be fixed before merge
- Description of issue
- Suggested fix

**[SUGGESTION]** Nice to have improvement
- Description
- Rationale

**[QUESTION]** Clarification needed
- What I don't understand
```

## Examples

**Good PR:**
- Clear description with context
- Small, focused changes
- Tests included
- Documentation updated
- No CI failures
- Follows team conventions

**Needs Work:**
- Large unfocused changes
- Missing tests
- Unclear purpose
- Multiple unrelated fixes
- Doesn't follow naming conventions

## Team Contacts

- Architecture questions: @tech-lead
- Security concerns: @security-team
- DevOps/CI issues: @devops
- Testing questions: @qa-lead
```

**Why this works:**
- Captures institutional knowledge
- Ensures consistent reviews
- New team members learn standards
- Reduces review time with clear criteria
- Project skill: checked into git, team-wide

---

## Key Patterns Across Examples

### 1. Clear Trigger Words
Every description includes specific terms users would naturally mention:
- File types: "PDF", "Excel", "API"
- Actions: "review", "analyze", "generate"
- Domains: "financial", "commit messages", "documentation"

### 2. Quick Start Section
Shows immediate value with a concrete example before diving into details.

### 3. Structured Instructions
Step-by-step guidance that Claude can follow reliably:
- Numbered phases
- Decision trees
- Checklists
- Clear conditionals

### 4. Concrete Examples
Show don't tell: actual inputs and outputs, not just descriptions.

### 5. Progressive Disclosure
Main instructions in SKILL.md, detailed reference in separate files, scripts for execution.

### 6. Best Practices Section
Capture expertise and common pitfalls to avoid repeated mistakes.

## Skill Creation Tips from Examples

**When designing your skill, ask:**

1. **Specificity:** Could Claude confuse when to use this vs another skill?
   - Add more specific trigger words
   - Narrow the scope

2. **Instructions:** Could someone unfamiliar follow these steps?
   - Make more explicit
   - Add decision criteria
   - Include examples

3. **Examples:** Do examples cover common use cases?
   - Add more diverse scenarios
   - Show edge cases
   - Include failure modes

4. **Activation:** Would users naturally mention trigger words?
   - Test with sample prompts
   - Add synonyms to description
   - Include file extensions

5. **Maintenance:** Will this stay relevant as code changes?
   - Version in git (project skills)
   - Document assumptions
   - Make it easy to update
