# Command Examples and Usage Patterns

This document provides detailed command examples and usage patterns for texlive-ja-textlint Docker images.

## Docker Operations

### Building Images
```bash
# Build Alpine variant (recommended)
docker build -f alpine/Dockerfile -t texlive-ja-textlint:alpine .

# Build Debian variant
docker build -f debian/Dockerfile -t texlive-ja-textlint:debian .

# Build with custom tag
docker build -f alpine/Dockerfile -t my-texlive:latest .

# Multi-architecture build
docker buildx build --platform linux/amd64,linux/arm64 -f alpine/Dockerfile -t ghcr.io/smkwlab/texlive-ja-textlint:2025b --push .
```

### Running Containers
```bash
# Basic compilation
docker run --rm -v $(pwd)/tests:/workspace texlive-ja-textlint:alpine latexmk main.tex

# Interactive session
docker run --rm -it -v $(pwd):/workspace -w /workspace texlive-ja-textlint:alpine bash

# With custom working directory
docker run --rm -v $(pwd)/my-thesis:/workspace -w /workspace texlive-ja-textlint:alpine latexmk thesis.tex
```

### Registry Operations
```bash
# Tag for registry
docker tag texlive-ja-textlint:alpine ghcr.io/smkwlab/texlive-ja-textlint:2025b

# Push to GitHub Container Registry
docker push ghcr.io/smkwlab/texlive-ja-textlint:2025b

# Pull from registry
docker pull ghcr.io/smkwlab/texlive-ja-textlint:2025b
```

## LaTeX Compilation Examples

### Basic Compilation
```bash
# Undergraduate thesis compilation
docker run --rm -v $(pwd):/workspace -w /workspace texlive-ja-textlint:alpine platex sotsuron.tex
docker run --rm -v $(pwd):/workspace -w /workspace texlive-ja-textlint:alpine dvipdfmx sotsuron.dvi

# Graduate thesis compilation
docker run --rm -v $(pwd):/workspace -w /workspace texlive-ja-textlint:alpine platex thesis.tex
docker run --rm -v $(pwd):/workspace -w /workspace texlive-ja-textlint:alpine dvipdfmx thesis.dvi
```

### Advanced Compilation
```bash
# With bibliography
docker run --rm -v $(pwd):/workspace -w /workspace texlive-ja-textlint:alpine platex main.tex
docker run --rm -v $(pwd):/workspace -w /workspace texlive-ja-textlint:alpine pbibtex main
docker run --rm -v $(pwd):/workspace -w /workspace texlive-ja-textlint:alpine platex main.tex
docker run --rm -v $(pwd):/workspace -w /workspace texlive-ja-textlint:alpine platex main.tex

# Using latexmk (automated)
docker run --rm -v $(pwd):/workspace -w /workspace texlive-ja-textlint:alpine latexmk -pdf main.tex
docker run --rm -v $(pwd):/workspace -w /workspace texlive-ja-textlint:alpine latexmk -pv main.tex
```

### Cleanup Operations
```bash
# Clean auxiliary files
docker run --rm -v $(pwd):/workspace -w /workspace texlive-ja-textlint:alpine latexmk -c

# Clean all generated files including PDF
docker run --rm -v $(pwd):/workspace -w /workspace texlive-ja-textlint:alpine latexmk -C

# Manual cleanup
docker run --rm -v $(pwd):/workspace -w /workspace texlive-ja-textlint:alpine rm -f *.aux *.log *.toc *.lot *.lof
```

## textlint Usage Examples

### Basic Text Quality Checking
```bash
# Check all tex files
docker run --rm -v $(pwd):/workspace -w /workspace texlive-ja-textlint:alpine textlint *.tex

# Check specific file
docker run --rm -v $(pwd):/workspace -w /workspace texlive-ja-textlint:alpine textlint sotsuron.tex

# Auto-fix issues (use with caution)
docker run --rm -v $(pwd):/workspace -w /workspace texlive-ja-textlint:alpine textlint --fix *.tex
```

### Advanced textlint Operations
```bash
# Use custom configuration
docker run --rm -v $(pwd):/workspace -w /workspace texlive-ja-textlint:alpine textlint --config .textlintrc *.tex

# Output to file
docker run --rm -v $(pwd):/workspace -w /workspace texlive-ja-textlint:alpine textlint *.tex > textlint-report.txt

# Check with specific format
docker run --rm -v $(pwd):/workspace -w /workspace texlive-ja-textlint:alpine textlint --format table *.tex
```

## Version Management Examples

### Version Checking
```bash
# Check TeXLive version
docker run --rm texlive-ja-textlint:alpine tlmgr --version

# Check all package versions
docker run --rm texlive-ja-textlint:alpine tlmgr list --installed

# Check Node.js and npm versions
docker run --rm texlive-ja-textlint:alpine node --version
docker run --rm texlive-ja-textlint:alpine npm --version

# Check textlint version
docker run --rm texlive-ja-textlint:alpine npm list -g textlint
```

### Package Management
```bash
# List TeXLive packages
docker run --rm texlive-ja-textlint:alpine tlmgr list --installed | grep -i japanese

# Check specific package
docker run --rm texlive-ja-textlint:alpine kpsewhich jarticle.cls
docker run --rm texlive-ja-textlint:alpine kpsewhich plistings.sty
```

## Testing and Validation

### Comprehensive Testing
```bash
# Test Alpine build
docker build -f alpine/Dockerfile -t test-alpine .
cd tests && docker run --rm -v $(pwd):/workspace -w /workspace test-alpine latexmk main.tex

# Test Debian build
docker build -f debian/Dockerfile -t test-debian .
cd tests && docker run --rm -v $(pwd):/workspace -w /workspace test-debian latexmk main.tex

# Test textlint functionality
cd tests && docker run --rm -v $(pwd):/workspace -w /workspace test-alpine textlint main.tex
```

### Performance Testing
```bash
# Measure compilation time
time docker run --rm -v $(pwd)/tests:/workspace -w /workspace texlive-ja-textlint:alpine latexmk main.tex

# Check image size
docker images texlive-ja-textlint

# Memory usage monitoring
docker stats --no-stream $(docker run -d -v $(pwd):/workspace -w /workspace texlive-ja-textlint:alpine sleep 60)
```

## Ecosystem Integration Examples

### With latex-environment
```bash
# Test compatibility with latex-environment
cd ../latex-environment
docker build -t test-env .

# Test sotsuron-template compilation
cd ../sotsuron-template
docker run --rm -v $(pwd):/workspace -w /workspace texlive-ja-textlint:alpine latexmk sotsuron.tex
```

### Development Workflow
```bash
# Local development cycle
docker build -f alpine/Dockerfile -t dev-texlive .
cd tests
docker run --rm -v $(pwd):/workspace -w /workspace dev-texlive latexmk main.tex
docker run --rm -v $(pwd):/workspace -w /workspace dev-texlive textlint main.tex
```

## Maintenance Examples

### Image Cleanup
```bash
# Remove old images
docker rmi $(docker images -f "dangling=true" -q)

# Remove specific versions
docker rmi texlive-ja-textlint:old-version

# Clean build cache
docker builder prune
```

### Security Scanning
```bash
# Basic vulnerability scan (if trivy is installed)
trivy image texlive-ja-textlint:alpine

# Check for outdated packages
docker run --rm texlive-ja-textlint:alpine npm audit
```