# smkwlab/texlive-ja-textlint

- textlint 入りコンパクトな日本語向け TeXLive Docker イメージ

## Supported tags / タグ一覧

### 推奨イメージ
- [`latest`, `2025h`](./debian/Dockerfile)
  - お使いの環境に合わせて自動的に最適なイメージを選択
  - Intel Mac/Windows: 軽量・高速版
  - Apple Silicon Mac: 互換性重視版

### 個別指定イメージ
- [`alpine`, `2025h-alpine`](./alpine/Dockerfile)
  - Intel Mac/Windows専用（軽量・高速）
  - Apple Silicon Macでは動作しません
- [`debian`, `2025h-debian`](./debian/Dockerfile)
  - すべての環境で動作（互換性重視）

## Install / インストール

GitHub Container Registry からインストールできます。

### GitHub Container Registry

```bash
# 推奨: 環境に合わせて自動選択
docker pull ghcr.io/smkwlab/texlive-ja-textlint:2025h

# 最新版（2025hと同じ）
docker pull ghcr.io/smkwlab/texlive-ja-textlint:latest
```

## Usage / 使い方

```bash
# 推奨: 環境に合わせて自動選択
$ docker run --rm -it -v $PWD:/workdir ghcr.io/smkwlab/texlive-ja-textlint:2025h \
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
