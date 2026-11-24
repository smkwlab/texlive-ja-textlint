# smkwlab/texlive-ja-textlint

- textlint 入りコンパクトな日本語向け TeXLive Docker イメージ

## Supported tags / タグ一覧

### 推奨イメージ
- `latest`, `2026e`
  - お使いの環境に合わせて自動的に最適なイメージを選択
  - **アーキテクチャごとにベースが異なる**ので、libc に依存する話では下記を確認してください
  - amd64（Intel Mac / Windows / Linux）: [Alpine](./alpine/Dockerfile) ベース（軽量・高速、libc は musl）
  - arm64（Apple Silicon Mac、Graviton など）: [Debian](./debian/Dockerfile) ベース（互換性重視、libc は glibc）
  - ベースを固定したい場合は、下記の個別指定イメージを使ってください

### 個別指定イメージ
- [`alpine`, `2026e-alpine`](./alpine/Dockerfile)
  - Alpine ベース（libc は musl）
  - amd64 専用（軽量・高速）
  - arm64 では動作しません
- [`debian`, `2026e-debian`](./debian/Dockerfile)
  - Debian ベース（libc は glibc）
  - amd64 / arm64 の両方で動作（互換性重視）

## Install / インストール

GitHub Container Registry からインストールできます。

### GitHub Container Registry

```bash
# 推奨: 環境に合わせて自動選択
docker pull ghcr.io/smkwlab/texlive-ja-textlint:2026e

# 最新版（2026eと同じ）
docker pull ghcr.io/smkwlab/texlive-ja-textlint:latest
```

## Usage / 使い方

```bash
# 推奨: 環境に合わせて自動選択
$ docker run --rm -it -v $PWD:/workdir ghcr.io/smkwlab/texlive-ja-textlint:2026e \
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
