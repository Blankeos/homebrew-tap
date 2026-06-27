class Uplate < Formula
  desc "CLI for initializing/upgrading boilerplates from git."
  homepage "https://github.com/uplate/uplate"
  version "0.0.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/uplate/uplate/releases/download/v0.0.1/uplate-aarch64-apple-darwin.tar.xz"
      sha256 "b9766f5ea7c5ba4ca40ed6d8bccc081ed5f0bbb1b2fb4b40a79813475693b13b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/uplate/uplate/releases/download/v0.0.1/uplate-x86_64-apple-darwin.tar.xz"
      sha256 "8526748c9cc8caa9fc86c1af49fd581d5fc010869c63a168934b7c80775cba62"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/uplate/uplate/releases/download/v0.0.1/uplate-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "61cc41ab7a1de6a0df8f049f36808c397350d95ce5d9d78293f5a210a9050956"
    end
    if Hardware::CPU.intel?
      url "https://github.com/uplate/uplate/releases/download/v0.0.1/uplate-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e21d9e7162e4d08d8930d7dffbb56c42d007f1e29b48e5c2d2e765d50ba2b69b"
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
    bin.install "uplate" if OS.mac? && Hardware::CPU.arm?
    bin.install "uplate" if OS.mac? && Hardware::CPU.intel?
    bin.install "uplate" if OS.linux? && Hardware::CPU.arm?
    bin.install "uplate" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
