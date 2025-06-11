# smkwlab/texlive-ja-textlint

- textlint 入りコンパクトな日本語向け TeXLive Docker イメージ

## Supported tags / タグ一覧

### Architecture-Optimized Tags (推奨)
- [`latest`, `2025b`](./debian/Dockerfile) (**アーキテクチャ最適化**)
  - AMD64: Alpine-based (軽量・高速)
  - ARM64: Debian-based (互換性重視)
  - 透明なアーキテクチャ選択: 同じタグで最適なイメージを自動取得

### Traditional Tags (従来タグ)
- [`alpine`, `2025b-alpine`](./alpine/Dockerfile)
  - AMD64のみ対応
- [`debian`, `2025b-debian`](./debian/Dockerfile)
  - AMD64, ARM64 (Apple Silicon) 対応

## Install / インストール

GitHub Container Registry からインストールできます。

### GitHub Container Registry

```bash
# 推奨: アーキテクチャ最適化イメージ
docker pull ghcr.io/smkwlab/texlive-ja-textlint:2025b

# 最新版（2025bと同じ）
docker pull ghcr.io/smkwlab/texlive-ja-textlint:latest
```

## Usage / 使い方

```bash
# アーキテクチャ最適化イメージ使用（推奨）
$ docker run --rm -it -v $PWD:/workdir ghcr.io/smkwlab/texlive-ja-textlint:2025b \
    sh -c 'latexmk -C main.tex && latexmk main.tex && latexmk -c main.tex'

# latest タグでも同じ結果
$ docker run --rm -it -v $PWD:/workdir ghcr.io/smkwlab/texlive-ja-textlint:latest \
    sh -c 'latexmk -C main.tex && latexmk main.tex && latexmk -c main.tex'
```

詳しくは、[使い方](./docs/usage.md) を参照してください。

## Contributing / コントリビュートについて

バグ修正は歓迎します。

現在、機能追加やバグ以外の修正は、基本的に受け付けていません。

機能を追加したい場合は、このイメージを基に拡張したイメージを作ることができます。

詳しくは、[使い方「イメージを拡張する」](./docs/usage.md) を参照してください。

## License / ライセンス

MIT (c)

---

Forked from [Paperist/texlive-ja] \(under the MIT License\).

[Paperist/texlive-ja]: https://github.com/Paperist/texlive-ja
