#!/bin/sh
# Verify that the textlint bundled in the image actually works, not merely that
# it starts. Each fixture carries a violation it is built to trigger, so a rule
# that stops firing means its plugin or preset no longer resolves -- the class
# of breakage a bare `textlint --version` cannot see.
set -eu

cd "$(dirname "$0")"

expect_rule() {
  file=$1
  rule=$2

  # textlint exits non-zero whenever it reports anything, which is the expected
  # outcome here, so the run must not abort the script.
  output=$(textlint -f json "$file" || true)

  if ! printf '%s' "$output" | grep -q "$rule"; then
    echo "FAIL: $file did not report $rule" >&2
    echo "textlint output was:" >&2
    printf '%s\n' "$output" >&2
    exit 1
  fi

  echo "ok: $file reported $rule"
}

expect_rule fixture.tex ja-technical-writing/sentence-length
expect_rule fixture.html ja-technical-writing/ja-no-mixed-period

echo "textlint check passed"
