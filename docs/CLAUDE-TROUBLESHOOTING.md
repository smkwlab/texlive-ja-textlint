# Troubleshooting Guide

This document provides troubleshooting information for common issues with texlive-ja-textlint Docker images.

## Common Issues

### Build failures
- Check base image availability
- Verify TeXLive mirror accessibility
- Validate package.json syntax
- Check Docker daemon memory limits

### Japanese font issues
- Verify IPAex font installation
- Check font cache generation
- Test with sample Japanese documents
- Validate character encoding (UTF-8)

### textlint problems
- Check Node.js version compatibility
- Verify textlint rule installation
- Test with minimal configuration
- Check npm package integrity

## Debug Commands

### TeXLive Environment
```bash
# Check TeXLive installation
docker run --rm texlive-ja-textlint:alpine kpsewhich article.cls
docker run --rm texlive-ja-textlint:alpine kpsewhich jarticle.cls

# Check current TeXLive version
docker run --rm texlive-ja-textlint:alpine tlmgr --version

# List installed packages
docker run --rm texlive-ja-textlint:alpine tlmgr list --installed

# Test Japanese font access
docker run --rm texlive-ja-textlint:alpine fc-list | grep IPA
```

### textlint Testing
```bash
# Check textlint version
docker run --rm texlive-ja-textlint:alpine npm list -g textlint

# Check textlint configuration
docker run --rm texlive-ja-textlint:alpine npx textlint --init

# Test textlint functionality
cd tests && docker run --rm -v $(pwd):/workspace -w /workspace texlive-ja-textlint:alpine textlint main.tex
```

### Compilation Testing
```bash
# Test Japanese LaTeX compilation
cd tests && docker run --rm -v $(pwd):/workspace -w /workspace texlive-ja-textlint:alpine platex main.tex
cd tests && docker run --rm -v $(pwd):/workspace -w /workspace texlive-ja-textlint:alpine dvipdfmx main.dvi

# Test bibliography processing
cd tests && docker run --rm -v $(pwd):/workspace -w /workspace texlive-ja-textlint:alpine pbibtex main

# Test with latexmk
cd tests && docker run --rm -v $(pwd):/workspace -w /workspace texlive-ja-textlint:alpine latexmk main.tex
```

### Image Inspection
```bash
# Inspect image layers
docker history texlive-ja-textlint:alpine

# Check image size
docker images texlive-ja-textlint

# Get detailed image information
docker inspect texlive-ja-textlint:alpine
```

## Shell Command Gotchas

### Backticks in gh pr create/edit
When using `gh pr create` or `gh pr edit` with `--body`, backticks (`) in the body text are interpreted as command substitution by the shell. This causes errors like:
```
permission denied: .devcontainer/devcontainer.json
command not found: 2025c-test
```

**Solution**: Always escape backticks with backslashes when using them in PR bodies:
```bash
# Wrong - will cause errors
gh pr create --body "Updated `file.txt` to version `1.2.3`"

# Correct - escaped backticks
gh pr create --body "Updated \`file.txt\` to version \`1.2.3\`"
```

## MCP Tools Usage

### GitHub Operations
Use MCP tools instead of `gh` command for GitHub operations:
- **Development**: Use `mcp__gh-toshi__*` tools for development work
- **Student testing**: Use `mcp__gh-k19__*` tools only when testing student workflows