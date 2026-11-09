#!/usr/bin/env bash
# Make the formula that dist generates pass `brew style` and `brew audit
# --strict`. dist's template has no smoke test, formats a hash literal in a way
# Homebrew's style rules reject, repeats the version that Homebrew derives from
# the URL, and names a license that is not in Homebrew's SPDX list. This script
# adjusts exactly those things. It is idempotent and never touches URLs or
# checksums.
#
# Usage: scripts/polish-formula.sh Formula/hyperion-lsp.rb
set -euo pipefail

formula="${1:?usage: polish-formula.sh <formula.rb>}"

# Homebrew derives the version from the release URL.
sed -i '/^  version "[^"]*"$/d' "$formula"

# PolyForm Shield 1.0.0 is a valid SPDX id, but Homebrew's list lacks it.
sed -i 's|^  license "PolyForm-Shield-1\.0\.0"$|  # PolyForm Shield 1.0.0 is source-available; Homebrew has no SPDX entry for it.\n  license :cannot_represent|' "$formula"

# Smoke test: the binary runs and reports the formula's version.
if ! grep -q '^  test do$' "$formula"; then
  # The formula's final line is the `end` closing the class.
  last="$(tail -n 1 "$formula")"
  [ "$last" = "end" ] || { echo "unexpected formula layout: last line is '$last'" >&2; exit 1; }
  head -n -1 "$formula" > "$formula.new"
  cat >> "$formula.new" <<'RUBY'

  test do
    assert_match version.to_s, shell_output("#{bin}/hyperion-lsp --version")
  end
end
RUBY
  mv "$formula.new" "$formula"
fi

# Homebrew's own style autocorrections (alignment, frozen constants, commas).
if command -v brew >/dev/null 2>&1; then
  brew style --fix "$formula"
fi
ruby -c "$formula" >/dev/null
