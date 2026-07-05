class Iconmate < Formula
  desc "CLI to fetch icons and save them into your Vite, NextJS, or similar TypeScript project"
  homepage "https://github.com/Blankeos/iconmate"
  version "1.2.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Blankeos/iconmate/releases/download/v1.2.1/iconmate-aarch64-apple-darwin.tar.xz"
      sha256 "846b6bbcd8e0e33a1ad9381d74aea894b9209b62d7f363ce860ceae74e1c672f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Blankeos/iconmate/releases/download/v1.2.1/iconmate-x86_64-apple-darwin.tar.xz"
      sha256 "b219b6d428016810d29c00656325a1eab9094f616d26b72ad586f553ef62388b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Blankeos/iconmate/releases/download/v1.2.1/iconmate-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "11133740f6d59417c68b6872813b12632be3d90df3877a77c0dbd1944c3670c6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Blankeos/iconmate/releases/download/v1.2.1/iconmate-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a8d45a90b1f964fe094197cb656129e781af2668609fc36d56188c4d4f87e674"
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
    bin.install "iconmate" if OS.mac? && Hardware::CPU.arm?
    bin.install "iconmate" if OS.mac? && Hardware::CPU.intel?
    bin.install "iconmate" if OS.linux? && Hardware::CPU.arm?
    bin.install "iconmate" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
