class Crabcode < Formula
  desc "Rust AI CLI Coding Agent with a beautiful terminal UI"
  homepage "https://github.com/blankeos/crabcode"
  version "0.0.11"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/blankeos/crabcode/releases/download/v0.0.11/crabcode-aarch64-apple-darwin.tar.xz"
      sha256 "7393aa258eb35d4c4fddc7c6423753ef8bea1391eb1726d3b8474edfe16bb6af"
    end
    if Hardware::CPU.intel?
      url "https://github.com/blankeos/crabcode/releases/download/v0.0.11/crabcode-x86_64-apple-darwin.tar.xz"
      sha256 "88bf124d1e6d54cef59d7f1deb5cf06111b888700b37aab3a004c9817fc30132"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/blankeos/crabcode/releases/download/v0.0.11/crabcode-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "5d4a1fb5be3fd5b2a2c62a1559c89afbee05064ddb23bed873e9e786eb49a67e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/blankeos/crabcode/releases/download/v0.0.11/crabcode-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "bbe7c803c34c29dfc732aecb86f288f306e58a25e0231b05ce70d2867b137f76"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "crabcode"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "crabcode"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "crabcode"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "crabcode"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
