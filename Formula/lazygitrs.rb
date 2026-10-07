class Lazygitrs < Formula
  desc "A faster, memory-safe, more ergonomic slopfork of lazygit"
  homepage "https://github.com/blankeos/lazygitrs"
  version "0.0.39"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/blankeos/lazygitrs/releases/download/v0.0.39/lazygitrs-aarch64-apple-darwin.tar.xz"
      sha256 "efa3f94c5f5da9fe4de18b3cb5b445aadf3a421af1d0b47aa0c2b13f5b89243a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/blankeos/lazygitrs/releases/download/v0.0.39/lazygitrs-x86_64-apple-darwin.tar.xz"
      sha256 "cd0aae83a0bf798dc4c34f2b63c6d00aa5d2af712c63a70f5e9acf30e112e978"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/blankeos/lazygitrs/releases/download/v0.0.39/lazygitrs-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "aedc7ffb17b500cdc25bef72c3d0c282fa4c9ca58bf633ed64424c0550dbc1b8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/blankeos/lazygitrs/releases/download/v0.0.39/lazygitrs-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c90ef19b8c348722c58c35343f04bc19cc126484c84bccb957fbdb520aecafee"
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
      bin.install "lazygitrs"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "lazygitrs"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "lazygitrs"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "lazygitrs"
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
