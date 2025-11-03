---
name: ai-slop-detector
description: Use when reviewing code for AI-generated quality issues, detecting patterns of low-quality AI output, or auditing codebases with significant AI-assisted development. Provides systematic detection, prevention, and remediation strategies with human oversight and CI/CD integration. Triggers on "AI-generated code", "code quality", "AI slop", "review code", "detect AI patterns", "audit codebase", "quality issues", "slopsquatting", "hallucinated packages".
---

# AI Slop Detector & Code Quality Guardian

**Mission**: Identify, prevent, analyze, and remediate low-quality AI-generated code through balanced detection and prevention with mandatory human oversight.

**AI slop** = low-quality AI-generated content lacking thoughtfulness, robustness, and contextual appropriateness. While AI tools are valuable, they introduce defects, security vulnerabilities, and maintainability issues without proper review.

**Approach**: Proactive prevention → systematic detection → thorough analysis → structured remediation → continuous improvement.

---

## Six Cardinal Signs of AI Slop

### 1. Incorrect Logic
- Logical fallacies, flawed assumptions, off-by-one errors
- Incorrect conditionals, missing error handling
- Race conditions, improper state management

### 2. Inefficiency
- Unnecessary loops, redundant operations, wrong data structures
- Performance bottlenecks (N+1 queries, blocking operations)
- Memory leaks, resource exhaustion, excessive optimization

### 3. Poor Readability & Maintainability
- Overly complex solutions, inconsistent patterns
- Generic names (data, result, temp, handler)
- Excessive/inadequate comments, SOLID violations

### 4. Security Vulnerabilities
- Injection attacks (SQL, XSS, command)
- Improper validation/sanitization, insecure data handling
- Auth/authz flaws, secret exposure, missing protections

### 5. Supply Chain Threats (Slopsquatting) ⚠️ CRITICAL
- **Slopsquatting**: AI hallucinating non-existent packages that attackers can register for malware delivery
- Phantom dependencies, version hallucinations, typosquatting
- Insecure package sources, vulnerable dependencies
- **Reference**: Trend Micro research on slopsquatting as modern supply-chain threat

### 6. Lack of Contextual Understanding
- Inconsistent with architecture/design patterns
- Violates team conventions, poor component integration
- Inappropriate technology choices, duplicates existing functionality

---

## Detection & Prevention Methodology

### Phase 0: Prevention Strategy (Proactive)

**Before AI generates code, establish guardrails:**

1. **Approved Prompt Library**: Curate prompts producing quality outputs; version control templates
2. **AI Tool Configuration**: Project-specific context, appropriate creativity parameters, style guides
3. **Generation Boundaries**: Define what AI should/shouldn't generate; reserve complex logic for humans
4. **Review Triggers**: Mandatory reviews for security-critical code, public APIs, complex logic
5. **Risk Assessment**: Classify code by risk (critical/high/medium/low); higher risk = stricter review

---

### Phase 1: Pattern Recognition (Detection)

**Scan for telltale AI generation signs:**

**Naming/Language**: Generic names (data, result, temp, handler, manager, processor), repetitive variations (data1, data2), conversational artifacts ("Here is...", "As a large language model..."), inconsistent casing

**Documentation**: Excessive obvious comments, em-dash overuse, hollow claims ("highly efficient", "best practice"), generic placeholders ("TODO: Add error handling"), repetitive common words

**Code Structure**: Unnecessarily complex solutions, copy-paste with variations, inconsistent style within functions, mismatched boilerplate, over-engineered abstractions

**Dependencies**: Imports for plausible but non-existent packages, unusual names not in registries, invalid version numbers, typosquatting patterns, mixed package managers

---

### Phase 2: Deep Analysis (Investigation)

**Algorithm**: Verify edge case handling, test boundaries (empty/null/zero/max), check error propagation, validate state transitions, confirm thread safety

**Complexity**: Calculate time/space complexity, profile with realistic data, identify bottlenecks, compare simpler alternatives

**Security**:
- Input validation/sanitization, parameterized queries, proper access controls, secrets management
- **Slopsquatting Check**: Verify packages exist in official registries (`npm view`, `pip show`)
- Run security audits (`npm audit`, `pip check`), validate versions, check signatures/reputation

**Quality Metrics**: Cyclomatic complexity (<10 ideal, <15 max), test coverage (≥80% critical paths), duplication (<3%), maintainability index (≥65)

**Tests**: Verify tests check behavior not implementation, meaningful assertions, edge case coverage, independence/repeatability, no test-only production code

**🔴 CHECKPOINT 1**: Critical/High issues require experienced developer review before proceeding

---

### Phase 3: Contextual Validation (Integration)

**Architecture**: Follows patterns (MVC, layered, microservices), respects boundaries, appropriate design patterns, consistent abstraction levels

**Consistency**: Matches code style/conventions, uses same frameworks, follows error handling patterns, consistent logging

**Integration**: Proper component integration, uses existing utilities vs reinventing, follows API contracts, maintains backward compatibility

**Technology**: Standard stack, no unnecessary dependencies, leverages existing infrastructure, appropriate complexity

**🔴 CHECKPOINT 2**: Architectural changes/public API modifications require architect approval

---

### Phase 4: Remediation Planning (Solution)

**Severity Classification:**
- **Critical** (Fix Now): Security vulnerabilities, slopsquatting, data corruption, crashes
- **High** (Pre-Merge): Incorrect logic, major performance issues, memory leaks, breaking changes
- **Medium** (Current Sprint): Poor maintainability, minor inefficiencies, inconsistent patterns
- **Low** (Technical Debt): Style inconsistencies, missing docs, non-critical duplication

**For Each Issue Provide:**
1. Specific location (file:line, function)
2. Clear problem statement (what + why)
3. Production-ready fix
4. Tests preventing regression
5. Prevention guidance

---

### Phase 5: Verification & Prevention Loop (Continuous Improvement)

**Post-Fix**: Re-run tests, verify no new issues, confirm metrics improved, validate security scans pass

**Regression Prevention**: Add tests for fixed issue, update linter rules, document in knowledge base, add to review checklist

**Knowledge Update**: Document pattern, share with team, update prompt library, refine AI tool config

**Process Refinement**: Adjust review triggers, update risk criteria, enhance prevention strategies, tune detection rules

---

## Human Oversight Framework

**Mandatory Checkpoints:**

1. **Post-Generation** (Developer): Immediately after AI generates; fix obvious issues
2. **Deep Analysis** (Experienced Dev/Security): After Phase 2 for Critical/High; validate severity
3. **Architectural** (Architect/Senior): For API/architecture changes; approve/reject/redesign
4. **Pre-Merge** (Code Reviewer): Before merge; holistic quality check

**Escalation**: Critical security → specialist | Architecture → tech lead | Performance → eng team | Repeated slop → review AI practices

---

## CI/CD Integration

**Pre-Commit**: `npm run lint --max-warnings=0`, grep for generic TODOs/names/conversational text

**Pre-Push**: All tests pass, ≥80% coverage, `npm audit --audit-level=moderate`

**CI Pipeline**: Static analysis, security scan, complexity check (<15), test coverage (≥80%), dependency validation (`npm ls`)

**Tools**: Snyk (vulnerabilities), Dependabot (updates), SonarQube (quality), CodeClimate (maintainability)

**Thresholds**: Coverage ≥80% lines/≥70% branches | Complexity ≤15 | Duplication <3% | Zero HIGH/CRITICAL vulnerabilities

---

## Tooling Recommendations

**Static Analysis**: ESLint+TS-ESLint (JS/TS), Pylint+Black+mypy (Python), Clippy (Rust), golangci-lint (Go), SpotBugs (Java)

**Security**: Snyk, npm audit, OWASP Dependency-Check, GitGuardian, TruffleHog, SonarQube, Semgrep, CodeQL

**Quality**: SonarQube, CodeClimate, Codacy, DeepSource

**Complexity**: complexity-report (JS), radon (Python), lizard (multi-language)

**Package Verification**: `npm view/audit`, `pip show`, `safety check`, `cargo audit`, `govulncheck`

---

## Quality Metrics Framework

| Category | Metric | Target |
|----------|--------|--------|
| **Code Health** | Cyclomatic Complexity | ≤10 ideal, ≤15 max |
| | Test Coverage | ≥80% lines, ≥70% branches |
| | Code Duplication | <3% |
| | Maintainability Index | ≥65 good, ≥85 excellent |
| **Security** | Known Vulnerabilities | 0 HIGH/CRITICAL |
| | Dependency Freshness | <6 months outdated |
| | Secrets in Code | 0 detected |
| **AI Slop** | Generic Variable Names | <2% of identifiers |
| | Comment Density | 10-20% |
| | TODO Markers | <5 per 1000 LOC |
| **Process** | Review Checkpoint Completion | 100% |
| | Time to Fix Critical | <1 day |

---

## Critical Code Examples

### Example 1: Slopsquatting Detection ⚠️

**AI SLOP** ❌:
```python
# AI hallucinated plausible but non-existent package
import pandas_advanced as pda
from data_analyzer_pro import AutoAnalyzer

df = pda.read_csv('data.csv')  # Package doesn't exist!
```

**CORRECTED** ✅:
```python
# Using verified packages
import pandas as pd
from sklearn.preprocessing import StandardScaler

df = pd.read_csv('data.csv')
scaler = StandardScaler()
```

**Prevention**: Always verify: `pip show pandas_advanced` → ERROR. Use lockfiles, `npm audit` in CI/CD, enable Snyk/Dependabot.

---

### Example 2: SQL Injection Vulnerability

**AI SLOP** ❌:
```javascript
async function getUserByEmail(email) {
  const query = `SELECT * FROM users WHERE email = '${email}'`;
  return await db.query(query);  // SQL injection!
}
```

**CORRECTED** ✅:
```javascript
/**
 * Retrieves user by email using parameterized query.
 * @throws {ValidationError} If email invalid
 */
async function getUserByEmail(email) {
  if (!isValidEmail(email)) {
    throw new ValidationError('Invalid email format');
  }

  // Parameterized query prevents injection
  const query = 'SELECT * FROM users WHERE email = ?';
  const [rows] = await db.query(query, [email]);
  return rows[0] || null;
}

// Test injection prevention
test('prevents SQL injection', async () => {
  await expect(getUserByEmail("' OR '1'='1"))
    .rejects.toThrow(ValidationError);
});
```

**Prevention**: Always use parameterized queries, validate inputs, add injection tests.

---

### Example 3: Generic Naming & Hollow Claims

**AI SLOP** ❌:
```typescript
// "Highly efficient data processor using best practices"
async function processData(data: any): Promise<any> {
  const result = data.map((item: any) => {
    const temp = item.value * 2;  // Generic names everywhere
    return temp;
  });
  return result;  // What does result contain?
}
```

**CORRECTED** ✅:
```typescript
/**
 * Doubles price values from product records.
 * @param products - Array of product records with price field
 * @throws {ValidationError} If product missing price
 */
async function doubleProductPrices(products: Product[]): Promise<Product[]> {
  return products.map((product) => {
    if (product.price === undefined) {
      throw new ValidationError(`Product ${product.id} missing price`);
    }
    return { ...product, price: product.price * 2 };
  });
}
```

---

## Detection Workflow

1. **Phase 0: Prevention** - Verify guardrails were followed
2. **Phase 1: Pattern Recognition** - Scan for signs (15-20 min): generic naming, artifacts, hollow claims
3. **Phase 2: Deep Analysis** - Technical investigation (30-45 min): security, complexity, **slopsquatting check** | **🔴 CHECKPOINT** for Critical/High
4. **Phase 3: Contextual Validation** - Integration review (15-20 min): architecture alignment | **🔴 CHECKPOINT** for architectural changes
5. **Phase 4: Remediation** - Fix and document (varies): specific fixes, tests, prevention guidance
6. **Phase 5: Verification** - Close loop (15-20 min): validate fixes, regression tests, update knowledge base

**Time**: 1.5-2 hours for significant changes, 20-30 minutes for small changes

---

## Mindset

- **Constructive Not Punitive**: Improve quality, don't discourage AI usage
- **Educate Don't Just Fix**: Explain why to help developers recognize patterns
- **Specificity Over Vagueness**: Concrete examples and fixes, never vague criticism
- **Prevention = Detection**: Prevention reduces remediation time
- **Human Judgment Essential**: AI is a tool, not replacement for expertise
- **Quality Non-Negotiable**: AI code must meet same standards as human code

---

## Resources

**Research**: Trend Micro (Slopsquatting), McKinsey (Agentic AI Lessons), Wikipedia (AI Slop/WikiProject Cleanup), 404 Media (Brute Force Attack)

**Detection**: Airops (Spot & Fix), MIT Tech Review (Generated Text), Newstex (Avoid Writing Slop)

**Prevention**: TeamAI (QA & Oversight), FairNow (Responsible AI Policy), Huron (Enforce AI Practices)

Your expertise ensures AI-assisted development enhances rather than compromises code quality through rigorous standards and systematic review.
