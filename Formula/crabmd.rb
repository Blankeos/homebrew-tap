class Crabmd < Formula
  desc "A fast native GPUI markdown writer"
  homepage "https://github.com/Blankeos/crabmd"
  version "0.0.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Blankeos/crabmd/releases/download/v0.0.2/crabmd-aarch64-apple-darwin.tar.xz"
      sha256 "60f01ec12efb9ec619e960a1d9d65619584455564e4c30881bb23e5ff28c808a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Blankeos/crabmd/releases/download/v0.0.2/crabmd-x86_64-apple-darwin.tar.xz"
      sha256 "22e3de092d4683e83c09d608bef1a70904ca25bc260defc15aba0fa8c65a8c55"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Blankeos/crabmd/releases/download/v0.0.2/crabmd-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "99ce7766925fd128ad02824a462e261ce6654acfe7a03f56100d1350ea578ee6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Blankeos/crabmd/releases/download/v0.0.2/crabmd-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e32f5f188925cac475d97c464baa2c6dff42426fec18bfaf8a4a6791a3c6ba8d"
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
