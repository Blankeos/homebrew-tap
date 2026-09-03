class Crabcode < Formula
  desc "Rust AI CLI Coding Agent with a beautiful terminal UI"
  homepage "https://github.com/blankeos/crabcode"
  version "0.0.12"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/blankeos/crabcode/releases/download/v0.0.12/crabcode-aarch64-apple-darwin.tar.xz"
      sha256 "f003a3124cdf246e73c168cf569a34c3ece12547eb6f8b8d127a305ed41d0162"
    end
    if Hardware::CPU.intel?
      url "https://github.com/blankeos/crabcode/releases/download/v0.0.12/crabcode-x86_64-apple-darwin.tar.xz"
      sha256 "d9cec4a28f3b29745cd2fcf468aade6a6318dd60c73cdf5f60e29216b1b20df8"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/blankeos/crabcode/releases/download/v0.0.12/crabcode-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "0fabeee0ea46345c4979a50f6c8f0ea9c1ecd6cee225ae7cc30ced0601b514e5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/blankeos/crabcode/releases/download/v0.0.12/crabcode-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "515b2a027361808c1a830e61dd2314422ba38ae6fd2e6df1ca1e32f5b55526f6"
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
