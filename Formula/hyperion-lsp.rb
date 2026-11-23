class HyperionLsp < Formula
  desc "Java and Kotlin language server with Gradle and Maven project support"
  homepage "https://github.com/hyperion-lsp/hyperion-lsp"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hyperion-lsp/hyperion-lsp/releases/download/v0.1.2/hyperion-lsp-aarch64-apple-darwin.tar.xz"
      sha256 "9ca99ce6a145a7af56705b8592a1154efd25d657783e97a1851faebcb8d110f5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hyperion-lsp/hyperion-lsp/releases/download/v0.1.2/hyperion-lsp-x86_64-apple-darwin.tar.xz"
      sha256 "b5d74ee19b3e389284c582c419f17142bad5cb26effc1b8364c79f637dfecc60"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/hyperion-lsp/hyperion-lsp/releases/download/v0.1.2/hyperion-lsp-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "2d57f7f1d27f6eeab0e4e558f3b49abb0c65491bec86a297ba6e57d2cefd3e6f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hyperion-lsp/hyperion-lsp/releases/download/v0.1.2/hyperion-lsp-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "0bcf489f22726da337a3fa73aba5bd42ebde7bbf0b5e5d3742950fe430441bd1"
    end
  end
  # PolyForm Shield 1.0.0 is source-available; Homebrew has no SPDX entry for it.
  license :cannot_represent

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "hyperion-lsp"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "hyperion-lsp"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "hyperion-lsp"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "hyperion-lsp"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hyperion-lsp --version")
  end
end
