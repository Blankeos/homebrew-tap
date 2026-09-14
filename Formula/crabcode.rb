class Crabcode < Formula
  desc "Rust AI CLI Coding Agent with a beautiful terminal UI"
  homepage "https://github.com/blankeos/crabcode"
  version "0.0.13"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/blankeos/crabcode/releases/download/v0.0.13/crabcode-aarch64-apple-darwin.tar.xz"
      sha256 "90db65e7ef7919d46b5e0f4ff08a18c3b98c3aa7f70991ac058a5918caa7dcab"
    end
    if Hardware::CPU.intel?
      url "https://github.com/blankeos/crabcode/releases/download/v0.0.13/crabcode-x86_64-apple-darwin.tar.xz"
      sha256 "ab63aca890d22b7d14d9cd9cb7c885cfe97fd29664a3ee6c7ea552396649463c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/blankeos/crabcode/releases/download/v0.0.13/crabcode-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "50ef3f9050e74750a119d34112894b7aad5d0c19fdb39244f1d850f8a527d9ea"
    end
    if Hardware::CPU.intel?
      url "https://github.com/blankeos/crabcode/releases/download/v0.0.13/crabcode-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "05087f3f5e3e36b5811600432902da8126bcac089d88da1638942b3e93cd7c96"
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
