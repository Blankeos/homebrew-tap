class Crabenv < Formula
  desc "The simplest, opinionated way to keep .env files, schemas, and examples aligned."
  homepage "https://github.com/blankeos/crabenv"
  version "0.0.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/blankeos/crabenv/releases/download/v0.0.6/crabenv-aarch64-apple-darwin.tar.xz"
      sha256 "87662de552363aa5c93508b4d4edb696e85822a9e9391bcdba376ca603a6952c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/blankeos/crabenv/releases/download/v0.0.6/crabenv-x86_64-apple-darwin.tar.xz"
      sha256 "9b36966f1460398233b54c3452d37b6412cdf84d582793c2b1eb4d9d16a6a322"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/blankeos/crabenv/releases/download/v0.0.6/crabenv-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "5f95f6e4c5b9f9e8275e33ba2f1b7136927fa4171440491cd39b693feb61556e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/blankeos/crabenv/releases/download/v0.0.6/crabenv-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "73d6aed7df82ad7fc83d1d9d30b413ead9d46680d46b7b1e1efeb886e1c123be"
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
      bin.install "crabenv"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "crabenv"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "crabenv"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "crabenv"
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
