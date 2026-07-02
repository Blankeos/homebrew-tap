class Crabenv < Formula
  desc "The simplest, opinionated way to keep .env files, schemas, and examples aligned."
  homepage "https://github.com/blankeos/crabenv"
  version "0.0.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/blankeos/crabenv/releases/download/v0.0.4/crabenv-aarch64-apple-darwin.tar.xz"
      sha256 "38d9f405c955e58cbd78cea71487f2d4ee85c9918a0bcebe3b3c38d8b240cb1b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/blankeos/crabenv/releases/download/v0.0.4/crabenv-x86_64-apple-darwin.tar.xz"
      sha256 "5c6e5e49f9d3c7fcd84060d50f4c47e654a4711deda2fef3505e6aacbf9c86a6"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/blankeos/crabenv/releases/download/v0.0.4/crabenv-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "751be9d4e6c6819c114230ff952ba19e7e217238d54ba36c9616a3fc1e7c53d0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/blankeos/crabenv/releases/download/v0.0.4/crabenv-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "9921c6ea832447b700f6375bb628f39647b18406403760ccf0b3e49d36a844cb"
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
    bin.install "crabenv" if OS.mac? && Hardware::CPU.arm?
    bin.install "crabenv" if OS.mac? && Hardware::CPU.intel?
    bin.install "crabenv" if OS.linux? && Hardware::CPU.arm?
    bin.install "crabenv" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
