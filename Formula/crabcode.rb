class Crabcode < Formula
  desc "Rust AI CLI Coding Agent with a beautiful terminal UI"
  homepage "https://github.com/blankeos/crabcode"
  version "0.0.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/blankeos/crabcode/releases/download/v0.0.6/crabcode-aarch64-apple-darwin.tar.xz"
      sha256 "13443701b288475d6a56ae55d2fadf128acc957a24d93ab8f7fea37b5094c1b5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/blankeos/crabcode/releases/download/v0.0.6/crabcode-x86_64-apple-darwin.tar.xz"
      sha256 "39147664e4f3992264db5b9dda7b8abc0e24bd1895e0f4f644b8e295f5fe9394"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/blankeos/crabcode/releases/download/v0.0.6/crabcode-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "2bab5bc48caaa3af54b4733df56b7c3f790b4cdb267babcd1e375b042099822b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/blankeos/crabcode/releases/download/v0.0.6/crabcode-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e5b5fa356b887bc13d7e33719d0cdeb69023e12a8bde343d92b784fb4aabf3a9"
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
