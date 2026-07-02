class Crabenv < Formula
  desc "The simplest, opinionated way to keep .env files, schemas, and examples aligned."
  homepage "https://github.com/blankeos/crabenv"
  version "0.0.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/blankeos/crabenv/releases/download/v0.0.3/crabenv-aarch64-apple-darwin.tar.xz"
      sha256 "53185a7a15a52df946a24a0cf281ae268b8f0300aa16f6dca9bb7dd9167d6143"
    end
    if Hardware::CPU.intel?
      url "https://github.com/blankeos/crabenv/releases/download/v0.0.3/crabenv-x86_64-apple-darwin.tar.xz"
      sha256 "62de01d4afb58130e693ca65dab20830627b728e59efca38bacd55e48b1f91cb"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/blankeos/crabenv/releases/download/v0.0.3/crabenv-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e5a7f13348da5addd71e16b947f897ad1da0fa48dd2eedff697f9290801b9f91"
    end
    if Hardware::CPU.intel?
      url "https://github.com/blankeos/crabenv/releases/download/v0.0.3/crabenv-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "7f2aeb2e9c7ee21fd1a8bea313be59842da27d89e126acffca9e714c01d95ba1"
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
