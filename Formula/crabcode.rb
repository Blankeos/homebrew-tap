class Crabcode < Formula
  desc "Rust AI CLI Coding Agent with a beautiful terminal UI"
  homepage "https://github.com/blankeos/crabcode"
  version "0.0.8"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/blankeos/crabcode/releases/download/v0.0.8/crabcode-aarch64-apple-darwin.tar.xz"
      sha256 "952ed1da9d6e16e14395a007df8e0cb3113380a714796e8de4518f7272224ee3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/blankeos/crabcode/releases/download/v0.0.8/crabcode-x86_64-apple-darwin.tar.xz"
      sha256 "94814000cab065f22df1570676d74d55d8d63cd95698004aefdceb043b831bd8"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/blankeos/crabcode/releases/download/v0.0.8/crabcode-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "378cbf254f62dc0a2e55b1d4389dd4a47dbc504a255a8a78eb58ecd7cdd518b6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/blankeos/crabcode/releases/download/v0.0.8/crabcode-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d676aff71e34ca448c7008709bbf54fe5248e871c9c9e69be9bdd375eff504f9"
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
