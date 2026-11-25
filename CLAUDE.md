# CLAUDE.md

Docker images for Japanese LaTeX compilation with textlint support. Foundational infrastructure for the thesis-environment ecosystem at Kyushu Sangyo University.

## Quick Start

### Build Images
```bash
# Alpine variant (recommended; AMD64 only)
docker build -f alpine/Dockerfile -t texlive-ja-textlint:alpine .

# Debian variant (AMD64 and ARM64)
docker build -f debian/Dockerfile -t texlive-ja-textlint:debian .
```

Published images are built by CI, never from a local build -- see Registry
Operations below. For a local multi-architecture check, see "Local Testing" in
[docs/CLAUDE-DEVELOPMENT.md](docs/CLAUDE-DEVELOPMENT.md).

### Test Compilation
```bash
# Test Japanese LaTeX
docker run --rm -v $(pwd)/tests:/workspace texlive-ja-textlint:alpine latexmk main.tex

# Test textlint functionality
docker run --rm -v $(pwd)/tests:/workspace -w /workspace texlive-ja-textlint:alpine textlint main.tex
```

### Registry Operations

Images are published by pushing a git tag, which runs
`.github/workflows/build-tag.yml`. Each architecture is built on a runner of
that architecture, and the `create-manifests` job then assembles the tags:
`<tag>` and `latest` mix AMD64=Alpine with ARM64=Debian, while `<tag>-debian`
and `debian` carry both architectures of the Debian build.

Do not tag a local image as `:<tag>` and push it by hand. A local build covers
one architecture, so that replaces the mixed manifest and leaves the other
architecture resolving to an image never built for it.

```bash
# Pull what CI published
docker pull ghcr.io/smkwlab/texlive-ja-textlint:2026e
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
- `2026e` - Latest release at time of writing (also published as `latest`; see README.md for the current list)
- `2026d` - Previous update
- Multi-architecture: AMD64, ARM64 -- note that `2026e` and `latest` are
  architecture-mixed manifests: AMD64 resolves to the Alpine build (musl),
  ARM64 to the Debian build (glibc). See `create-manifests` in
  `.github/workflows/build-tag.yml`. Use `-debian` for glibc on both.

### Version Checking
```bash
# Check TeXLive version
docker run --rm texlive-ja-textlint:alpine tlmgr --version

# Check textlint version
docker run --rm texlive-ja-textlint:alpine textlint --version
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
- **student-repo-management**: Automated builds

## Detailed Documentation

- **[Development Guide](docs/CLAUDE-DEVELOPMENT.md)** - Architecture, workflows, security guidelines
- **[Troubleshooting](docs/CLAUDE-TROUBLESHOOTING.md)** - Common issues, debug commands
- **[Command Examples](docs/CLAUDE-EXAMPLES.md)** - Detailed usage patterns, testing procedures