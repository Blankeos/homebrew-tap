class Crabcode < Formula
  desc "Rust AI CLI Coding Agent with a beautiful terminal UI"
  homepage "https://github.com/blankeos/crabcode"
  version "0.0.7"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/blankeos/crabcode/releases/download/v0.0.7/crabcode-aarch64-apple-darwin.tar.xz"
      sha256 "5efe4a22fe78ff4f4dfc0bc2d25f0fe9d6fb5a793e34d5d7b9d6ae073ad0ba52"
    end
    if Hardware::CPU.intel?
      url "https://github.com/blankeos/crabcode/releases/download/v0.0.7/crabcode-x86_64-apple-darwin.tar.xz"
      sha256 "e71a7992cf964f026d0608facbd6c24450747035b5a888ece90b2f832a71cc3e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/blankeos/crabcode/releases/download/v0.0.7/crabcode-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "6cfb2b06d7efaaa60e8abcbbbeca4217c18d8c4b96f848e9ff5aff5523d640b7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/blankeos/crabcode/releases/download/v0.0.7/crabcode-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a0ad38bed0031e4448be3fa74eb30bc6d66d9f69f8bacc5b5d30380fcade7205"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
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
    bin.install "crabcode" if OS.mac? && Hardware::CPU.arm?
    bin.install "crabcode" if OS.mac? && Hardware::CPU.intel?
    bin.install "crabcode" if OS.linux? && Hardware::CPU.arm?
    bin.install "crabcode" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
