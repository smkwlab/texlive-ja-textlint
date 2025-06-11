# smkwlab/texlive-ja-textlint

- textlint 入りコンパクトな日本語向け TeXLive Docker イメージ

## Supported tags / タグ一覧

- [`latest`](./debian/Dockerfile) (**Architecture-optimized**)
  - AMD64: Alpine-based (compact, ~0.65GB)
  - ARM64: Debian-based (full-featured, ~1.55GB)
  - アーキテクチャ最適化: AMD64 では Alpine、ARM64 では Debian を使用
- [`alpine`](./alpine/Dockerfile)
  - Only AMD64 supported.
  - AMD64 のみ対応しています
- [`debian`](./debian/Dockerfile)
  - AMD64, ARM64 supported.
  - AMD64, ARM64 (M1 mac) に対応しています
- [`*-mixed`](./debian/Dockerfile) (**Deprecated**: Use `latest` instead)
  - Same as `latest` but will be removed in future versions
  - `latest` と同じですが、将来のバージョンで削除予定

## Install / インストール

GitHub Container Registry からインストールできます。

### GitHub Container Registry

```bash
docker pull ghcr.io/smkwlab/texlive-ja-textlint:latest
docker image tag ghcr.io/smkwlab/texlive-ja-textlint:latest smkwlab/texlive-ja-textlint:latest
```

## Usage / 使い方

```bash
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
