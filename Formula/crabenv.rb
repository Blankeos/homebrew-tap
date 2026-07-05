class Crabenv < Formula
  desc "The simplest, opinionated way to keep .env files, schemas, and examples aligned."
  homepage "https://github.com/blankeos/crabenv"
  version "0.0.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/blankeos/crabenv/releases/download/v0.0.5/crabenv-aarch64-apple-darwin.tar.xz"
      sha256 "65e4e2485edb34e0922c1dc8a8aaa99560bfa7de1a31a196a1144c89676fd365"
    end
    if Hardware::CPU.intel?
      url "https://github.com/blankeos/crabenv/releases/download/v0.0.5/crabenv-x86_64-apple-darwin.tar.xz"
      sha256 "3eaa26ce9965e368757f5b065577ba806490136e618c18aaa0bf8254ed862e62"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/blankeos/crabenv/releases/download/v0.0.5/crabenv-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "403b97679e59bf69e64518d22e52c7eb458d0506252821b244353d2763f9f1aa"
    end
    if Hardware::CPU.intel?
      url "https://github.com/blankeos/crabenv/releases/download/v0.0.5/crabenv-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "bdf096adaea1615ecebca350cb8e710443c484346cde449bc40da895a03440fb"
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
