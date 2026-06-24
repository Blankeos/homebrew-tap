class Crabenv < Formula
  desc "The simplest, opinionated way to keep .env files, schemas, and examples aligned."
  homepage "https://github.com/blankeos/crabenv"
  version "0.0.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/blankeos/crabenv/releases/download/v0.0.2/crabenv-aarch64-apple-darwin.tar.xz"
      sha256 "5513273d0b0cc1bb385f93e6b67f23aaa635c5c94f3cbafd27170ad51d3a70cf"
    end
    if Hardware::CPU.intel?
      url "https://github.com/blankeos/crabenv/releases/download/v0.0.2/crabenv-x86_64-apple-darwin.tar.xz"
      sha256 "dad67444f0e9499214baab52ce74ed2d18225e8fe130d6d07e1addc6f1833e40"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/blankeos/crabenv/releases/download/v0.0.2/crabenv-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "19d155ac33657f80b0675af4603bb7fec98e8adc9ffa929bb4e20f0335316fed"
    end
    if Hardware::CPU.intel?
      url "https://github.com/blankeos/crabenv/releases/download/v0.0.2/crabenv-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "cbbdfd0c16781a8284b64bc13317264d7614d3a7f24a637ccfccdd3a46b5dfd9"
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
