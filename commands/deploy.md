---
description: Deploy to specified environment with safety checks
argument-hint: "[environment: staging|production]"
allowed-tools: Read, Bash(git *), Bash(npm *), Bash(docker *), Grep, Glob
---

# Deployment Workflow

Deploy the current project to the specified environment.

## Target Environment

$ARGUMENTS

## Pre-Deployment Checklist

Before deploying, verify:

### 1. Code Quality
- [ ] All tests pass (`/test`)
- [ ] Code review completed (`/review`)
- [ ] No linter errors
- [ ] No security vulnerabilities

### 2. Version Control
- [ ] All changes committed
- [ ] Working directory is clean
- [ ] On correct branch for deployment
- [ ] Remote is up to date

### 3. Configuration
- [ ] Environment variables configured
- [ ] Database migrations ready (if any)
- [ ] Dependencies up to date
- [ ] Build artifacts generated

### 4. Safety Checks
- [ ] Deployment environment confirmed
- [ ] Rollback plan ready
- [ ] Monitoring in place
- [ ] Team notified (for production)

## Deployment Instructions

1. **Detect deployment method**:
   - Check for CI/CD config (GitHub Actions, GitLab CI, etc.)
   - Look for deployment scripts (deploy.sh, Makefile)
   - Check for platform config (Vercel, Netlify, Docker, etc.)

2. **Execute deployment**:
   - Follow project-specific deployment process
   - Monitor progress and logs
   - Verify deployment success

3. **Post-deployment**:
   - Run smoke tests
   - Check application health
   - Monitor for errors
   - Document deployment

## Warning

**Production deployments require extra caution!**
- Confirm environment before proceeding
- Ensure all team members are aware
- Have rollback procedure ready
