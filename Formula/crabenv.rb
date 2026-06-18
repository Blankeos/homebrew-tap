class Crabenv < Formula
  desc "The simplest, opinionated way to keep .env files, schemas, and examples aligned."
  homepage "https://github.com/blankeos/crabenv"
  version "0.0.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/blankeos/crabenv/releases/download/v0.0.1/crabenv-aarch64-apple-darwin.tar.xz"
      sha256 "fb003f4424226090ab95ee15be8e44f54211c0638b0ffa86b62adc6e5ebd497a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/blankeos/crabenv/releases/download/v0.0.1/crabenv-x86_64-apple-darwin.tar.xz"
      sha256 "975cc890ef17bd0d79f172bc077c31f1065a233f7662d2eb8d7f82d7974fae24"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/blankeos/crabenv/releases/download/v0.0.1/crabenv-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "afd03f7b845253d788f6929e925660656ac0f4c9bc54f861b5f8173ad415fdeb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/blankeos/crabenv/releases/download/v0.0.1/crabenv-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f019fd71d96428fec52fcd7d57e14e039e2d88ea57963d160e9d8a0b365f056b"
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
