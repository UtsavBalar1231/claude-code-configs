---
name: creating-skills
description: Interactive wizard for creating custom Claude Code skills. Use when the user wants to create a new skill, write a skill, build a custom capability, or asks how to make a skill. Guides through requirements, validation, and best practices. Triggers on "create skill", "help me write a skill", "make a skill".
---

# Creating Skills

An interactive wizard for creating high-quality Claude Code skills. This skill guides you through the entire process from concept to validated SKILL.md file.

## How This Works

I'll ask you questions to understand what you want to build, then guide you through creating a properly structured skill with validation and testing.

## Step 1: Understanding Your Skill Concept

First, let me understand what you want to create:

**Questions to ask:**
1. What task or workflow should this skill help with?
2. What triggers should activate this skill? (specific file types, keywords, domains)
3. Who will use this skill? (just you, your team, specific role)

**What makes a good skill:**
- Solves a specific, repeatable task
- Has clear activation triggers
- Represents expertise that needs consistency
- Would save time by not re-explaining each session

## Step 2: Determine Skill Type

Ask: **Should this be a personal or project skill?**

**Personal skills** (`~/.claude/skills/`):
- Your individual workflows and preferences
- Experimental skills you're developing
- Available across all your projects
- Not shared with team

**Project skills** (`.claude/skills/`):
- Team workflows and conventions
- Project-specific expertise
- Checked into git
- Automatically available to team members

## Step 3: Create the Skill Name

Generate a skill name following these rules:

**Requirements:**
- Lowercase letters, numbers, and hyphens only
- Maximum 64 characters
- Cannot contain "anthropic" or "claude"
- Should be descriptive and memorable

**Good examples:**
- `pdf-form-filling`
- `sales-report-generator`
- `api-documentation-writer`

**Bad examples:**
- `PDF_Processing` (uppercase, underscore)
- `skill123` (not descriptive)
- `claude-helper` (contains reserved word)

Present suggested name and ask for confirmation or changes.

## Step 4: Craft the Description

Create a description that includes BOTH:
1. **What the skill does** (capabilities)
2. **When to use it** (trigger conditions)

**Description Requirements:**
- Maximum 1024 characters
- Include specific trigger words (file extensions, domain terms, action verbs)
- Cannot contain XML tags
- Must be specific enough for Claude to know when to activate

**Template:**
```
[Action verbs describing capabilities]. Use when [specific trigger conditions, file types, keywords the user might mention].
```

**Examples:**

**Good:**
```
Extract text and tables from PDF files, fill forms, merge documents. Use when working with PDF files or when the user mentions PDFs, forms, or document extraction.
```

**Bad:**
```
Helps with documents
```
(Too vague, no triggers)

**Analysis checklist:**
- [ ] Includes specific file types or domains
- [ ] Contains action verbs
- [ ] Has "Use when..." or similar trigger guidance
- [ ] User would naturally mention these trigger words
- [ ] Under 1024 characters

## Step 5: Structure the Skill Content

Create the SKILL.md content with these sections:

### Required Structure

```markdown
# [Skill Name]

## Quick Start
[Immediate example of using this skill - show don't tell]

## Instructions
[Step-by-step guidance for Claude to follow]
[Be specific and actionable]
[Include decision points and edge cases]

## Examples
[Concrete examples showing the skill in action]
[Cover common use cases]
[Show expected outputs]

## Best Practices
[Key considerations]
[Common pitfalls to avoid]
[Performance tips]
```

### Optional Sections

- **Requirements**: Dependencies, pre-installed packages needed
- **Error Handling**: Common errors and how to handle them
- **Advanced Usage**: Complex scenarios
- **Version History**: Track changes over time

## Step 6: Add Supporting Files (Optional)

Ask if additional files would help:

**Documentation files:**
- `reference.md` - Detailed API or technical reference
- `examples.md` - Extended examples collection
- `workflows.md` - Common workflow patterns

**Scripts:**
- `scripts/helper.py` - Executable utilities
- `scripts/validate.sh` - Validation scripts
- Make scripts executable: `chmod +x scripts/*.py`

**Templates:**
- `templates/report.md` - Document templates
- `templates/config.json` - Configuration templates

**Reference from SKILL.md:**
```markdown
For advanced usage, see [reference.md](reference.md).

Run the helper script:
```bash
python scripts/helper.py input.txt
```
```

## Step 7: Tool Restrictions (Optional)

Ask if the skill should restrict tool access using `allowed-tools`:

**When to use:**
- Read-only skills (use: Read, Grep, Glob)
- Data analysis only (use: Read, Bash for data commands)
- Security-sensitive workflows

**Example frontmatter with restrictions:**
```yaml
---
name: safe-file-reader
description: Read files without making changes. Use when you need read-only file access.
allowed-tools: Read, Grep, Glob
---
```

If not specified, Claude asks for permission to use tools as normal.

## Step 8: Validation

Before finalizing, validate the skill:

### YAML Validation
```bash
# Check frontmatter syntax
head -n 10 ~/.claude/skills/[skill-name]/SKILL.md
```

**Verify:**
- [ ] Opening `---` on line 1
- [ ] Closing `---` before content
- [ ] Valid YAML (no tabs, proper indentation)
- [ ] Required fields: name, description
- [ ] Name format: lowercase, hyphens, max 64 chars
- [ ] Description under 1024 chars

### Description Effectiveness Analysis

**Score the description (show analysis):**
- Specificity: Does it include concrete trigger words?
- Completeness: Does it explain both WHAT and WHEN?
- Discoverability: Would a user naturally use these words?
- Uniqueness: Does it distinguish from other skills?

**Red flags:**
- Generic terms only ("helps with", "for files")
- No file extensions or domain terminology
- Missing "Use when..." guidance
- Too similar to existing skill descriptions

### File Structure Check
```bash
ls -la ~/.claude/skills/[skill-name]/
```

**Verify:**
- [ ] SKILL.md exists
- [ ] File paths use forward slashes (not backslashes)
- [ ] Scripts have execute permissions
- [ ] Referenced files actually exist

## Step 9: Generate Test Scenarios

Create 3-5 test prompts that should trigger the skill:

**Format:**
```markdown
## Test Scenarios

1. **Basic trigger**: "[prompt that should activate skill]"
   - Expected: Skill activates and [specific behavior]

2. **With context**: "[prompt mentioning key trigger words]"
   - Expected: Skill loads and [specific behavior]

3. **Edge case**: "[prompt that's borderline]"
   - Expected: Skill may activate if [conditions]
```

**Example for PDF skill:**
```
1. "Extract text from this PDF file"
2. "Help me fill out this PDF form"
3. "Can you read document.pdf and summarize it?"
```

## Step 10: Create and Verify

Execute the skill creation:

1. **Create directory:**
```bash
mkdir -p [path-to-skill]
```

2. **Write SKILL.md:**
```bash
cat > [path-to-skill]/SKILL.md << 'EOF'
[full content]
EOF
```

3. **Create supporting files** (if any)

4. **Set permissions** (if scripts):
```bash
chmod +x [path-to-skill]/scripts/*.py
```

5. **Verify creation:**
```bash
ls -la [path-to-skill]/
cat [path-to-skill]/SKILL.md | head -n 20
```

## Step 11: Testing Guide

Provide testing instructions:

```markdown
## Testing Your Skill

1. **Restart Claude Code** (changes take effect on restart)

2. **Test each scenario:**
   - Use the exact test prompts generated
   - Verify the skill activates (Claude should mention using it)
   - Check that the guidance is followed correctly

3. **Common issues:**
   - Skill doesn't activate → Description not specific enough
   - Wrong skill activates → Descriptions too similar
   - YAML errors → Check frontmatter syntax

4. **Debug mode:**
   ```bash
   claude --debug
   ```
   Shows skill loading errors

5. **Iterate:**
   - Edit SKILL.md based on test results
   - Refine description if activation is inconsistent
   - Add examples if Claude misunderstands instructions
   - Restart and test again
```

## Best Practices Summary

**Do:**
- Keep skills focused on one capability
- Write specific descriptions with trigger words
- Include concrete examples
- Test with real use cases
- Iterate based on activation patterns

**Don't:**
- Make skills too broad ("document processing")
- Use vague descriptions ("helps with data")
- Forget the "Use when..." guidance
- Skip validation steps
- Assume Claude will guess when to use it

**Remember:**
- Description is critical for discovery
- Progressive disclosure: SKILL.md → additional files
- Skills can work together (composability)
- Personal vs project: consider sharing needs
- Changes take effect on restart

## Troubleshooting

**Skill doesn't activate:**
1. Check description has specific trigger words
2. Verify YAML syntax is valid
3. Ensure file is in correct location
4. Restart Claude Code
5. Try more explicit prompts with trigger words

**Skill activates at wrong times:**
1. Description too broad or generic
2. Conflicts with other skill descriptions
3. Refine to be more specific

**Skill has errors:**
1. Check YAML frontmatter syntax
2. Verify file paths and references
3. Ensure scripts have execute permissions
4. Check for typos in tool names (allowed-tools)

## Additional Resources

For more examples of well-structured skills, see [examples.md](examples.md).

## Skill Creation Workflow

When a user asks to create a skill, follow this flow:

1. Ask questions to understand their needs (Step 1)
2. Determine personal vs project (Step 2)
3. Generate and validate name (Step 3)
4. Draft and analyze description (Step 4)
5. Structure content with their input (Step 5)
6. Ask about supporting files (Step 6)
7. Ask about tool restrictions (Step 7)
8. Validate everything (Step 8)
9. Generate test scenarios (Step 9)
10. Create all files (Step 10)
11. Provide testing guidance (Step 11)

Present each step clearly, wait for confirmation before proceeding, and show your validation analysis at each stage.
