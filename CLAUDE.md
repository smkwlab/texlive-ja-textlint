# CLAUDE.md

Docker images for Japanese LaTeX compilation with textlint support. Foundational infrastructure for the thesis-environment ecosystem at Kyushu Sangyo University.

## Quick Start

### Build Images
```bash
# Alpine variant (recommended)
docker build -f alpine/Dockerfile -t texlive-ja-textlint:alpine .

# Debian variant
docker build -f debian/Dockerfile -t texlive-ja-textlint:debian .

# Multi-architecture build
docker buildx build --platform linux/amd64,linux/arm64 -f alpine/Dockerfile -t ghcr.io/smkwlab/texlive-ja-textlint:2025b --push .
```

### Test Compilation
```bash
# Test Japanese LaTeX
docker run --rm -v $(pwd)/tests:/workspace texlive-ja-textlint:alpine latexmk main.tex

# Test textlint functionality
docker run --rm -v $(pwd)/tests:/workspace -w /workspace texlive-ja-textlint:alpine textlint main.tex
```

### Registry Operations
```bash
# Push to registry (maintainers only)
docker tag texlive-ja-textlint:alpine ghcr.io/smkwlab/texlive-ja-textlint:2025b
docker push ghcr.io/smkwlab/texlive-ja-textlint:2025b
```

## Image Structure

### Variants
- **Alpine** (recommended): Small, fast builds
- **Debian**: Traditional base, broader compatibility

### Components
- **TeXLive 2025**: Full Japanese LaTeX support
- **textlint**: Academic writing quality checker
- **Japanese fonts**: IPAex fonts included

## Version Management

### Current Tags
- `2025b` - Current stable release
- `2025a` - Previous update
- Multi-architecture: AMD64, ARM64

### Version Checking
```bash
# Check TeXLive version
docker run --rm texlive-ja-textlint:alpine tlmgr --version

# Check textlint version
docker run --rm texlive-ja-textlint:alpine npm list -g textlint
```

## File Structure

```
alpine/
├── Dockerfile              # Alpine build
├── package.json            # Node.js dependencies
└── texlive.profile         # TeXLive config

debian/
├── Dockerfile              # Debian build  
├── package.json            # Node.js dependencies
└── texlive.profile         # TeXLive config

tests/
├── main.tex                # Test document
└── index.bib               # Test bibliography
```

## Common Tasks

### Development Testing
```bash
# Local build and test
docker build -f alpine/Dockerfile -t test-image .
cd tests && docker run --rm -v $(pwd):/workspace -w /workspace test-image latexmk main.tex

# Test both variants
docker build -f debian/Dockerfile -t test-debian .
cd tests && docker run --rm -v $(pwd):/workspace -w /workspace test-debian latexmk main.tex
```

### Package Updates
```bash
# Update Node.js packages
cd alpine/ && npm update && npm audit fix

# Test updated packages
docker build -t test-image . && docker run --rm test-image textlint --version
```

## Ecosystem Dependencies

- **latex-environment**: Primary consumer
- **sotsuron-template**: Via latex-environment  
- **wr-template**: Weekly reports
- **thesis-management-tools**: Automated builds

## Detailed Documentation

- **[Development Guide](docs/CLAUDE-DEVELOPMENT.md)** - Architecture, workflows, security guidelines
- **[Troubleshooting](docs/CLAUDE-TROUBLESHOOTING.md)** - Common issues, debug commands
- **[Command Examples](docs/CLAUDE-EXAMPLES.md)** - Detailed usage patterns, testing procedures