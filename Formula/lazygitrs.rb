class Lazygitrs < Formula
  desc "A faster, memory-safe, more ergonomic slopfork of lazygit"
  homepage "https://github.com/blankeos/lazygitrs"
  version "0.0.24"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/blankeos/lazygitrs/releases/download/v0.0.24/lazygitrs-aarch64-apple-darwin.tar.xz"
      sha256 "a6289ac36e7fb33226e207a4456631346168c69b4105b4848a59083f3f3f4216"
    end
    if Hardware::CPU.intel?
      url "https://github.com/blankeos/lazygitrs/releases/download/v0.0.24/lazygitrs-x86_64-apple-darwin.tar.xz"
      sha256 "9deff0b3d9e72770601a4746077ceb7c370ba8796707cc2ab63dcf9b6b256147"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/blankeos/lazygitrs/releases/download/v0.0.24/lazygitrs-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7cd23b23501801dc1811fd079a850dc92699a2c7e27c77aa3e389319d75f90c4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/blankeos/lazygitrs/releases/download/v0.0.24/lazygitrs-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c8a36b44fc22e0f3847d21d3c7ae0b5e5331d2b95665c24683cf3bc6837748b9"
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
