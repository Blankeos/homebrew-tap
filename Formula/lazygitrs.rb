class Lazygitrs < Formula
  desc "A faster, memory-safe, more ergonomic slopfork of lazygit"
  homepage "https://github.com/blankeos/lazygitrs"
  version "0.0.23"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/blankeos/lazygitrs/releases/download/v0.0.23/lazygitrs-aarch64-apple-darwin.tar.xz"
      sha256 "245284386af9684baaddf8783de10102dc9ac71152db1b95230d717b81fdc52c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/blankeos/lazygitrs/releases/download/v0.0.23/lazygitrs-x86_64-apple-darwin.tar.xz"
      sha256 "d917e45daad77e7c7cebc85b12cddb2f0ea03c40878ca738a5545ffb5577fd9d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/blankeos/lazygitrs/releases/download/v0.0.23/lazygitrs-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "5dce288fa7b11225d34a150cef25d1ef797e293a568e83cdb2a1cff0796996a3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/blankeos/lazygitrs/releases/download/v0.0.23/lazygitrs-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "2f06be0192ca9e96438f7a9fbc578c613769cad9e39abde5a6978da291c59a67"
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
