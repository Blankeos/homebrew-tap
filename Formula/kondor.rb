class Kondor < Formula
  desc "Find and clear build leftovers (node_modules, target, caches) across all your projects"
  homepage "https://github.com/Blankeos/kondor"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Blankeos/kondor/releases/download/v0.1.1/kondor-cli-aarch64-apple-darwin.tar.gz"
      sha256 "0b1eb3e5bccb967b2ed7f0efff5fa943883932f265dcc1e85a5e7da60b444e10"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Blankeos/kondor/releases/download/v0.1.1/kondor-cli-x86_64-apple-darwin.tar.gz"
      sha256 "3d69cc11bab4353c184cbb9861cf70e02772e36aff4481c56f30efa7e22f31a5"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Blankeos/kondor/releases/download/v0.1.1/kondor-cli-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "965c7b36455268569ae633edc17a4d7cea90a9ae4689f2bf2e4b513094ff602d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Blankeos/kondor/releases/download/v0.1.1/kondor-cli-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "f943c7f7ef4e15b9e3bd7a83a36b83fd03b860919de56cd31eba156d7c6f2129"
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
      bin.install "kondor"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "kondor"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "kondor"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "kondor"
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
