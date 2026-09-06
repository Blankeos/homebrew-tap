class Lazygitrs < Formula
  desc "A faster, memory-safe, more ergonomic slopfork of lazygit"
  homepage "https://github.com/blankeos/lazygitrs"
  version "0.0.36"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/blankeos/lazygitrs/releases/download/v0.0.36/lazygitrs-aarch64-apple-darwin.tar.xz"
      sha256 "c033a431c32686f344efb7ebea169db2dae51dcbebb3b152bbe8fea2adf500de"
    end
    if Hardware::CPU.intel?
      url "https://github.com/blankeos/lazygitrs/releases/download/v0.0.36/lazygitrs-x86_64-apple-darwin.tar.xz"
      sha256 "c82e1a07d91e712279ed142aaede8bae387ad221b626b7fefd2c379decf42209"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/blankeos/lazygitrs/releases/download/v0.0.36/lazygitrs-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c715b13ef3c382aa62b041965aaab6f569a1388eb9e25665e985de9dd377544e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/blankeos/lazygitrs/releases/download/v0.0.36/lazygitrs-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "7a3b5d70524c0e7dd33c5c4f8bc477f0abb8738ce8dda945d9a67a1fad335752"
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
