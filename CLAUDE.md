# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with the texlive-ja-textlint repository.

## Repository Overview

This repository provides **Docker images for Japanese LaTeX compilation with textlint support**. It serves as the foundational infrastructure for the entire thesis-environment ecosystem at Kyushu Sangyo University. The images include TeXLive with full Japanese support, textlint for academic writing quality, and all necessary tools for containerized LaTeX development.

## Key Commands

### Docker Operations
```bash
# Build images
docker build -f debian/Dockerfile -t texlive-ja-textlint:debian .
docker build -f alpine/Dockerfile -t texlive-ja-textlint:alpine .

# Test compilation
docker run --rm -v $(pwd)/tests:/workspace texlive-ja-textlint:alpine latexmk main.tex

# Push to registry (maintainers only)
docker tag texlive-ja-textlint:alpine ghcr.io/smkwlab/texlive-ja-textlint:2025b
docker push ghcr.io/smkwlab/texlive-ja-textlint:2025b

# Multi-architecture build
docker buildx build --platform linux/amd64,linux/arm64 -f alpine/Dockerfile -t ghcr.io/smkwlab/texlive-ja-textlint:2025b --push .
```

### Testing Commands
```bash
# Test Japanese LaTeX compilation
cd tests && docker run --rm -v $(pwd):/workspace -w /workspace texlive-ja-textlint:alpine platex main.tex
cd tests && docker run --rm -v $(pwd):/workspace -w /workspace texlive-ja-textlint:alpine dvipdfmx main.dvi

# Test textlint functionality
cd tests && docker run --rm -v $(pwd):/workspace -w /workspace texlive-ja-textlint:alpine textlint main.tex

# Test bibliography processing
cd tests && docker run --rm -v $(pwd):/workspace -w /workspace texlive-ja-textlint:alpine pbibtex main
```

### Version Management
```bash
# Check current TeXLive version
docker run --rm texlive-ja-textlint:alpine tlmgr --version

# List installed packages
docker run --rm texlive-ja-textlint:alpine tlmgr list --installed

# Check textlint version
docker run --rm texlive-ja-textlint:alpine npm list -g textlint
```

## Architecture

### Image Variants
- **Alpine-based** (recommended): Smaller size, faster builds
- **Debian-based**: Traditional base, larger but more compatible

### Included Components
- **TeXLive 2025**: Full installation with Japanese support
- **platex/uplatex**: Japanese LaTeX engines  
- **pbibtex**: Japanese-aware bibliography processor
- **textlint**: Japanese academic writing linter
- **Node.js**: Runtime for textlint and extensions
- **Japanese fonts**: IPAex fonts and common Japanese typography

### Multi-Architecture Support
- **AMD64**: Intel/AMD x86_64 processors
- **ARM64**: Apple Silicon (M1/M2) and ARM servers
- **Automated builds**: GitHub Actions with buildx

## Version Strategy

### Calendar Versioning
Tags follow TeXLive release patterns:
- `2025` - Major TeXLive 2025 release
- `2025a` - First update with additional packages/fixes
- `2025b` - Second update (current)
- `2025c` - Potential third update

### Backward Compatibility
- Previous major versions maintained for 1 year
- Security updates provided for supported versions
- Migration guides provided for breaking changes

### Dependency Tracking
- Monitor TeXLive upstream releases
- Track textlint and Node.js compatibility
- Coordinate with latex-environment updates

## File Structure Conventions

### Docker Configuration
```
alpine/
├── Dockerfile              # Alpine-based build
├── package.json            # Node.js dependencies
├── package-lock.json       # Locked dependency versions
└── texlive.profile         # TeXLive installation profile

debian/
├── Dockerfile              # Debian-based build
├── package.json            # Node.js dependencies  
├── package-lock.json       # Locked dependency versions
└── texlive.profile         # TeXLive installation profile

tests/
├── main.tex                # Test document
├── index.bib               # Test bibliography
└── assets/                 # Test images and resources
```

### Configuration Files
- `texlive.profile`: TeXLive installation configuration
- `package.json`: textlint and Node.js package definitions
- `.github/workflows/`: Automated build and test workflows

## Development Workflow

### For Image Updates
1. **Update base components** (TeXLive, Node.js versions)
2. **Test builds locally** with both variants
3. **Run test suite** against sample documents
4. **Update version tags** following calendar versioning
5. **Create PR** with comprehensive testing
6. **Coordinate downstream updates** (latex-environment)

### For Package Updates
```bash
# Update Node.js packages
cd alpine/
npm update
npm audit fix

# Update lock files
npm install

# Test updated packages
docker build -t test-image .
docker run --rm test-image textlint --version
```

### For TeXLive Updates
1. Monitor [TeXLive releases](https://tug.org/texlive/)
2. Update installation profile if needed
3. Test package compatibility
4. Update documentation and examples
5. Coordinate ecosystem-wide testing

## Testing Guidelines

### Local Testing
```bash
# Build and test Alpine variant
docker build -f alpine/Dockerfile -t test-alpine .
cd tests && docker run --rm -v $(pwd):/workspace -w /workspace test-alpine latexmk main.tex

# Build and test Debian variant  
docker build -f debian/Dockerfile -t test-debian .
cd tests && docker run --rm -v $(pwd):/workspace -w /workspace test-debian latexmk main.tex

# Test multi-architecture compatibility
docker buildx build --platform linux/amd64,linux/arm64 -f alpine/Dockerfile .
```

### Integration Testing
- Test with latex-environment devcontainer
- Verify sotsuron-template compilation
- Check textlint rule compatibility
- Validate Japanese font rendering

### Performance Testing
- Measure image size and build times
- Test compilation speed benchmarks
- Monitor resource usage during builds
- Compare Alpine vs Debian performance

## Troubleshooting

### Common Issues

**Build failures:**
- Check base image availability
- Verify TeXLive mirror accessibility
- Validate package.json syntax
- Check Docker daemon memory limits

**Japanese font issues:**
- Verify IPAex font installation
- Check font cache generation
- Test with sample Japanese documents
- Validate character encoding (UTF-8)

**textlint problems:**
- Check Node.js version compatibility
- Verify textlint rule installation
- Test with minimal configuration
- Check npm package integrity

### Debug Commands
```bash
# Check TeXLive installation
docker run --rm texlive-ja-textlint:alpine kpsewhich article.cls
docker run --rm texlive-ja-textlint:alpine kpsewhich jarticle.cls

# Test Japanese font access
docker run --rm texlive-ja-textlint:alpine fc-list | grep IPA

# Check textlint configuration
docker run --rm texlive-ja-textlint:alpine npx textlint --init

# Inspect image layers
docker history texlive-ja-textlint:alpine
```

## Security Considerations

### Base Image Security
- Regular updates of Alpine/Debian base images
- Security scanning with GitHub Actions
- Vulnerability monitoring and patching
- Minimal package installation principle

### Supply Chain Security  
- Verify TeXLive package signatures
- Pin npm package versions with lock files
- Use official base images only
- Regular dependency auditing

## Ecosystem Integration

### Downstream Dependencies
- **latex-environment**: Primary consumer of these images
- **sotsuron-template**: Indirect dependency through latex-environment
- **wr-template**: Uses for weekly reports
- **thesis-management-tools**: Uses for automated builds

### Update Coordination
```
1. texlive-ja-textlint update
2. Test with latex-environment
3. Update latex-environment dependency
4. Propagate to all templates
5. Test complete ecosystem
```

### Version Compatibility
- Maintain compatibility matrix with latex-environment
- Coordinate major version updates
- Provide migration assistance
- Document breaking changes

## Release Process

### Automated Builds
- GitHub Actions build on every push
- Multi-architecture support via buildx
- Automated testing with sample documents
- Security scanning integration

### Manual Release Steps
1. **Update version tags** in GitHub
2. **Verify builds** across all architectures  
3. **Test downstream compatibility**
4. **Update documentation**
5. **Notify ecosystem maintainers**
6. **Monitor for issues**

### Rollback Procedures
- Keep previous versions available
- Document rollback process
- Test rollback scenarios
- Communicate with downstream projects

## Security and Permission Guidelines

### 🚨 CRITICAL: GitHub Administration Rules

#### Git and GitHub Operations
- **NEVER use `--admin` flag** with `gh pr merge` or similar commands
- **NEVER bypass Branch Protection Rules** without explicit user permission
- **ALWAYS respect the configured workflow**: approval process, status checks, etc.

#### When Branch Protection Blocks Operations
1. **Report the situation** to user with specific error message
2. **Explain available options**:
   - Wait for required approvals
   - Wait for status checks to pass
   - Use `--auto` flag for automatic merge after requirements met
   - Request explicit permission for admin override (emergency only)
3. **Wait for user instruction** - never assume intent

#### Proper Error Handling Example
```bash
# When this fails:
gh pr merge 90 --squash --delete-branch
# Error: Pull request is not mergeable: the base branch policy prohibits the merge

# CORRECT response:
echo "Branch Protection Rules prevent merge. Options:"
echo "1. Wait for required approvals (currently need: 1)"
echo "2. Wait for status checks (currently pending: build-and-release-pdf)"
echo "3. Use --auto to merge automatically when requirements met"
echo "4. Request admin override (emergency only)"
echo "Please specify how to proceed."

# WRONG response:
gh pr merge 90 --squash --delete-branch --admin  # NEVER DO THIS
```

#### Emergency Admin Override
- Only use `--admin` flag when explicitly requested by user
- Document the reason for override in commit/PR description
- Report the action taken and why it was necessary

### Rationale
Branch Protection Rules exist to:
- Ensure code quality through required reviews
- Prevent accidental breaking changes
- Maintain audit trail of changes
- Enforce consistent development workflow

Bypassing these rules undermines repository security and development process integrity.

## Contributing Guidelines

### Code Quality
- Test both Alpine and Debian variants
- Maintain multi-architecture compatibility
- Follow Docker best practices
- Minimize image size and layers

### Documentation
- Update README for user-facing changes
- Document breaking changes clearly
- Maintain compatibility information
- Include migration guides

### Testing Requirements
- All changes must pass automated tests
- Manual testing on target platforms
- Integration testing with latex-environment
- Performance regression testing

### Review Process
- Peer review for all changes
- Security review for dependency updates
- Ecosystem impact assessment
- Coordinated release planning

## MCP Tools Usage

### GitHub Operations
Use MCP tools instead of `gh` command for GitHub operations:
- **Development**: Use `mcp__gh-toshi__*` tools for development work
- **Student testing**: Use `mcp__gh-k19__*` tools only when testing student workflows

### Shell Command Gotchas

#### Backticks in gh pr create/edit
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

## Emergency Procedures

### Critical Security Updates
1. **Immediate assessment** of vulnerability impact
2. **Emergency build** with security patches
3. **Expedited testing** with minimal test suite
4. **Coordinated release** with downstream projects
5. **Post-incident review** and documentation

### Build System Failures
1. **Investigate root cause** (upstream, GitHub Actions, etc.)
2. **Implement workarounds** if possible
3. **Communicate status** to ecosystem users
4. **Document lessons learned**
5. **Improve resilience** for future incidents