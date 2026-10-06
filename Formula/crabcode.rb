class Crabcode < Formula
  desc "Rust AI CLI Coding Agent with a beautiful terminal UI"
  homepage "https://github.com/blankeos/crabcode"
  version "0.0.14"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/blankeos/crabcode/releases/download/v0.0.14/crabcode-aarch64-apple-darwin.tar.gz"
      sha256 "c79549aec4a43cd8e2e65f1783d9115014ea6b631539b61574e0491212c85ed6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/blankeos/crabcode/releases/download/v0.0.14/crabcode-x86_64-apple-darwin.tar.gz"
      sha256 "e435b788e17c66f7cdf26535f4b8e36ff0cb1e680d061e588f1a1c172903d3ca"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/blankeos/crabcode/releases/download/v0.0.14/crabcode-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "7e23e7c5284b8655fe95ad8a694b3a45992fc96e5299b104c05c8582f13adc98"
    end
    if Hardware::CPU.intel?
      url "https://github.com/blankeos/crabcode/releases/download/v0.0.14/crabcode-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "5d8d7804a9138d6641641251076f6299884f1ccecc990b3fe24ce340c18b3a51"
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
