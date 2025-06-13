# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This repository provides Docker images for Japanese LaTeX compilation with textlint integration. It creates compact Docker images with TeXLive and textlint for Japanese academic/technical document processing.

## Architecture

### Multi-platform Docker Images
- **Latest/Default**: Architecture-optimized approach (recommended)
  - AMD64: Alpine-based (~0.65GB) for maximum efficiency
  - ARM64: Debian-based (~1.55GB) for compatibility
- **Alpine variant**: Compact, AMD64 only (`alpine/`)
- **Debian variant**: Full-featured, AMD64 and ARM64 support (`debian/`)
- All images include the same textlint configuration and LaTeX packages

### Package Structure
- **TeXLive packages**: `collection-fontsrecommended`, `collection-langjapanese`, `collection-latexextra`, `latexmk`
- **Textlint plugins**: Japanese technical writing rules, spacing rules, LaTeX support
- **Multi-stage builds**: Separate installer and runtime stages for minimal image size

## Key Commands

### Docker Image Building
```bash
# Build Alpine variant (AMD64 only)
docker build -t texlive-ja-textlint:alpine alpine/

# Build Debian variant (multi-platform)
docker build -t texlive-ja-textlint:debian debian/
```

### LaTeX Compilation (via Docker)
```bash
# Basic compilation
docker run --rm -it -v $PWD:/workdir ghcr.io/smkwlab/texlive-ja-textlint:latest \
  sh -c 'latexmk -C main.tex && latexmk main.tex && latexmk -c main.tex'

# uplatex compilation (requires latexmkrc configuration)
docker run --rm -it -v $PWD:/workdir ghcr.io/smkwlab/texlive-ja-textlint:latest \
  latexmk -pv main.tex
```

### Testing
```bash
# Test LaTeX compilation in tests/ directory
cd tests/
latexmk -pv main.tex  # (when running inside container)
```

## Configuration Files

### latexmkrc Setup
For upLaTeX compilation, create `.latexmkrc`:
```perl
$latex = 'uplatex %O -synctex=1 -interaction=nonstopmode -file-line-error %S';
$bibtex = 'upbibtex %O %B';
$dvipdf = 'dvipdfmx %O -o %D %S';
$makeindex = 'upmendex %O -o %D %S';
$pdf_mode = 3;
```

### Font Configuration
- Use `OSFONTDIR` environment variable for custom fonts
- Add to latexmkrc: `ensure_path('OSFONTDIR', './fonts');`
- Hiragino fonts supported via `pxchfon-extras.def`

### VSCode Integration
Configure LaTeX Workshop to use this Docker image:
```json
{
  "latex-workshop.docker.enabled": true,
  "latex-workshop.docker.image.latex": "smkwlab/texlive-ja-textlint:latest"
}
```

## Textlint Configuration

The images include Japanese textlint rules:
- `textlint-rule-preset-ja-technical-writing`: Technical writing standards
- `textlint-rule-preset-ja-spacing`: Proper spacing rules
- `textlint-rule-no-mix-dearu-desumasu`: Consistent writing style
- `textlint-plugin-latex2e`: LaTeX document support

## CI/CD Pipeline

GitHub Actions automatically build and publish images:
- **Push to main**: Builds both Alpine and Debian variants (AMD64 only for development speed)
- **Tags**: Builds specific versions with full multi-platform support
- **Multi-platform**: AMD64 (Alpine) + ARM64 (Debian) architecture-optimized
- **ARM64 Performance**: Native ARM64 runners (ubuntu-24.04-arm) for 40% faster builds
- **Registry**: Images published to GitHub Container Registry (ghcr.io)

### Build Performance Optimization
- **AMD64**: Ubuntu runners with Alpine Linux builds (~12 minutes)
- **ARM64**: Native ARM64 runners (~12 minutes, free for public repos since Jan 2025)
- **Parallel Jobs**: All workflows use concurrent architecture-specific builds
- **Unified Strategy**: Same build process for main pushes, PRs, and releases
- **Performance**: ~12 minutes total (vs. ~60 minutes with emulation)