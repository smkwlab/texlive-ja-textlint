# 2025-mixed タグテスト計画

## 概要
アーキテクチャ別ベースOS戦略（AMD64: Alpine, ARM64: Debian）の実験的実装をテストします。

## テスト項目

### 1. ビルド確認
- [ ] GitHub Actions での `build-mixed` ジョブが成功する
- [ ] AMD64 イメージが Alpine ベースで作成される
- [ ] ARM64 イメージが Debian ベースで作成される  
- [ ] マルチプラットフォームマニフェストが正しく作成される

### 2. 機能テスト
- [ ] 日本語 LaTeX 文書のコンパイル（両アーキテクチャ）
- [ ] textlint による文書校正（両アーキテクチャ）
- [ ] latexmk による自動ビルド（両アーキテクチャ）

### 3. サイズ確認
- [ ] AMD64 イメージが ~0.65GB になる
- [ ] ARM64 イメージが ~1.55GB になる
- [ ] 従来の debian タグと機能的に同等

### 4. 互換性確認
- [ ] 既存の LaTeX プロジェクトが問題なく動作する
- [ ] 環境変数や設定が両アーキテクチャで一貫している
- [ ] VS Code LaTeX Workshop との連携

## 使用コマンド例

```bash
# AMD64 での使用例
docker run --rm -v $(pwd):/workdir ghcr.io/smkwlab/texlive-ja-textlint:2025-mixed platex document.tex

# ARM64 での使用例（M1 Mac）
docker run --rm -v $(pwd):/workdir ghcr.io/smkwlab/texlive-ja-textlint:2025-mixed platex document.tex
```

## 期待される結果
- 機能面では既存タグと同等
- AMD64 ユーザーはイメージサイズが約 58% 削減
- ARM64 ユーザーは既存と同じ安定性を維持