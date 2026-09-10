class Crabmd < Formula
  desc "A fast native GPUI markdown writer"
  homepage "https://github.com/Blankeos/crabmd"
  version "0.0.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Blankeos/crabmd/releases/download/v0.0.3/crabmd-aarch64-apple-darwin.tar.xz"
      sha256 "1438a10af697287fc496016ba3dde8ef22556ebe3103fc2484307a8576057a92"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Blankeos/crabmd/releases/download/v0.0.3/crabmd-x86_64-apple-darwin.tar.xz"
      sha256 "37057533898ae6dada469f830bc19cea93689854c987a55396f48c0ea00679b5"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Blankeos/crabmd/releases/download/v0.0.3/crabmd-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ff0924688a2c7feb276f09e2471744db23bedfc8abc0205229cd5897c7321ded"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Blankeos/crabmd/releases/download/v0.0.3/crabmd-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "7bc7500852e7904435fa872f700eeca9268b0124332724f8e04afb4fbfe5f7ae"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
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
      bin.install "crabmd"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "crabmd"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "crabmd"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "crabmd"
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
