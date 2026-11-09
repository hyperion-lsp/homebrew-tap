# Homebrew tap for Hyperion

[Homebrew](https://brew.sh) tap for [Hyperion](https://github.com/hyperion-lsp/hyperion-lsp),
a Java, Kotlin and Groovy language server. Installs the prebuilt `hyperion-lsp`
binary from the project's GitHub releases (macOS on Apple silicon and Intel,
Linux on x86_64 and aarch64).

## Install

```bash
brew install hyperion-lsp/tap/hyperion-lsp
```

Or add the tap first:

```bash
brew tap hyperion-lsp/tap
brew install hyperion-lsp
```

Upgrade with `brew update && brew upgrade hyperion-lsp`.

`hyperion-lsp` uses a JDK found on `PATH` or via `JAVA_HOME` for standard-library
support; it is not installed as a dependency. See the
[project README](https://github.com/hyperion-lsp/hyperion-lsp#readme) for editor
setup.

The software is source-available under the PolyForm Shield License 1.0.0, not an
OSI-approved open-source license.

## How the formula is maintained

`Formula/hyperion-lsp.rb` is not edited by hand. Each release of
`hyperion-lsp/hyperion-lsp` carries a generated `hyperion-lsp.rb` asset, and the
[`update`](.github/workflows/update.yml) workflow copies the latest one here
(hourly, and on demand), using this repository's own token. It commits only when
the file changed. The [`audit`](.github/workflows/audit.yml) workflow runs
`brew style` and `brew audit --strict` on it.

To pick up a new release immediately: Actions, "Update formula", "Run workflow",
or `gh workflow run update.yml -R hyperion-lsp/homebrew-tap`.
