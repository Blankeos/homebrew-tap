class Lazygitrs < Formula
  desc "A faster, memory-safe, more ergonomic slopfork of lazygit"
  homepage "https://github.com/blankeos/lazygitrs"
  version "0.0.29"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/blankeos/lazygitrs/releases/download/v0.0.29/lazygitrs-aarch64-apple-darwin.tar.xz"
      sha256 "2343433afbbcf7d840d7aad4484f5875ac48fd2ec415f894a927cda54351804c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/blankeos/lazygitrs/releases/download/v0.0.29/lazygitrs-x86_64-apple-darwin.tar.xz"
      sha256 "6f3d233df7f8ed21c701d61b68ab7155699e9308652be858d60f8459b684d483"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/blankeos/lazygitrs/releases/download/v0.0.29/lazygitrs-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "1947e29e91f982a75ad0c4f7b48cbb09432d800c0610024c1dcf5f66961503f6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/blankeos/lazygitrs/releases/download/v0.0.29/lazygitrs-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "05642a66ee9c54f5ee1406efcf3b39286795c7688d10367130c6ec4f08f24526"
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
    bin.install "lazygitrs" if OS.mac? && Hardware::CPU.arm?
    bin.install "lazygitrs" if OS.mac? && Hardware::CPU.intel?
    bin.install "lazygitrs" if OS.linux? && Hardware::CPU.arm?
    bin.install "lazygitrs" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
