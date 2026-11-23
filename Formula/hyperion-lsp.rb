class HyperionLsp < Formula
  desc "Java and Kotlin language server with Gradle and Maven project support"
  homepage "https://github.com/hyperion-lsp/hyperion-lsp"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hyperion-lsp/hyperion-lsp/releases/download/v0.1.3/hyperion-lsp-aarch64-apple-darwin.tar.xz"
      sha256 "c8e3253336b8c78f68138b6e396ea020bffd872aaf93a3f56f7be21ee38b7ff2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hyperion-lsp/hyperion-lsp/releases/download/v0.1.3/hyperion-lsp-x86_64-apple-darwin.tar.xz"
      sha256 "e070e4c07b56aefc65fa10c4655325af98edac0066aa54bd4c07424f20a97365"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/hyperion-lsp/hyperion-lsp/releases/download/v0.1.3/hyperion-lsp-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "681fa874ebe02bb18331cdc1414c77d7765c7144f51dd73b7a9b71c1ab34f296"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hyperion-lsp/hyperion-lsp/releases/download/v0.1.3/hyperion-lsp-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "71f354cc3d73beba24c9852db4df1179129c9111dc700704347bb432545d05ea"
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
