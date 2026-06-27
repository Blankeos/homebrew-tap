class Uplate < Formula
  desc "CLI for initializing/upgrading boilerplates from git."
  homepage "https://github.com/uplate/uplate"
  version "0.0.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/uplate/uplate/releases/download/v0.0.1/uplate-aarch64-apple-darwin.tar.xz"
      sha256 "b8a6a5c788ac1ffbd646b9123b079a240bbf2b2a2d06cb4c5c9c731fac29b0b1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/uplate/uplate/releases/download/v0.0.1/uplate-x86_64-apple-darwin.tar.xz"
      sha256 "05a18a96f018a88ca6baba28ec873c08aa1e8f05d29216ebdf55866c8b325c14"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/uplate/uplate/releases/download/v0.0.1/uplate-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "98df346395c641850a6ebbf30d9751869e7a9871fcf59ac065bbd9778872e7a9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/uplate/uplate/releases/download/v0.0.1/uplate-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "0774f97b7335b6d95d9b036dc4067e6c356b1179e53a5c6c6da40b36c13d320d"
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
