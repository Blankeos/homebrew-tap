class Lazygitrs < Formula
  desc "A faster, memory-safe, more ergonomic slopfork of lazygit"
  homepage "https://github.com/blankeos/lazygitrs"
  version "0.0.30"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/blankeos/lazygitrs/releases/download/v0.0.30/lazygitrs-aarch64-apple-darwin.tar.xz"
      sha256 "a10427d36e091683c7ad7a0cbd2f455637aced66e7b243cd5188afee28ed1bb7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/blankeos/lazygitrs/releases/download/v0.0.30/lazygitrs-x86_64-apple-darwin.tar.xz"
      sha256 "f09fa47cc007e25025a914649258e36bb0a6d712355f88e6bd30a27239beb19a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/blankeos/lazygitrs/releases/download/v0.0.30/lazygitrs-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "51faa5a1175a06eab306afab2c077b68fc1cd581e8b040a60638f89ffadd06f1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/blankeos/lazygitrs/releases/download/v0.0.30/lazygitrs-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "5382c84d462953989798b06a8d4db486a3aeb6e6326be2ecd1fe823b1773d7ff"
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
