class HyperionLsp < Formula
  desc "Java and Kotlin language server with Gradle and Maven project support"
  homepage "https://github.com/hyperion-lsp/hyperion-lsp"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hyperion-lsp/hyperion-lsp/releases/download/v0.1.0/hyperion-lsp-aarch64-apple-darwin.tar.xz"
      sha256 "691399045e6704b9eff76b46c1fc6658414fdf10521e5fcc5510fa51b5d7fb27"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hyperion-lsp/hyperion-lsp/releases/download/v0.1.0/hyperion-lsp-x86_64-apple-darwin.tar.xz"
      sha256 "2e8b2fed4fcae79adbd1d2db2f0d3df2ddd4f8ad5bd0e64f5088ee1f5c1bbab9"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/hyperion-lsp/hyperion-lsp/releases/download/v0.1.0/hyperion-lsp-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "fe385508349b39824ee30aafbb8f0583de36e8a0efb96af9328823d35215b8b1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hyperion-lsp/hyperion-lsp/releases/download/v0.1.0/hyperion-lsp-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "1cdddd44a2419806be4f73dc1952ed6448ee1c4481687cccbdff8021d25d8f49"
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
