class HyperionLsp < Formula
  desc "Java and Kotlin language server with Gradle and Maven project support"
  homepage "https://github.com/hyperion-lsp/hyperion-lsp"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hyperion-lsp/hyperion-lsp/releases/download/v0.1.1/hyperion-lsp-aarch64-apple-darwin.tar.xz"
      sha256 "ea08b851f894df2dc9c5643eb314f3cbba1b44b4e9dc640d0c44bb8781f13f80"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hyperion-lsp/hyperion-lsp/releases/download/v0.1.1/hyperion-lsp-x86_64-apple-darwin.tar.xz"
      sha256 "fea37fc4d156ab77e513f9764b430d2004063a6d0a5488139cda2a2d9c71c0fc"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/hyperion-lsp/hyperion-lsp/releases/download/v0.1.1/hyperion-lsp-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "4e50e708254857220ecb059f00d55a78763ca1344d077432ee825b6d4997764c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hyperion-lsp/hyperion-lsp/releases/download/v0.1.1/hyperion-lsp-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e5026f86485fc198b5d5698aedba8c96ca9217171c8000864a1575190e006dc7"
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
