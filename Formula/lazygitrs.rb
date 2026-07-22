class Lazygitrs < Formula
  desc "A faster, memory-safe, more ergonomic slopfork of lazygit"
  homepage "https://github.com/blankeos/lazygitrs"
  version "0.0.25"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/blankeos/lazygitrs/releases/download/v0.0.25/lazygitrs-aarch64-apple-darwin.tar.xz"
      sha256 "73584da40fb8c9b19c146c0194c4736c43d8eb2b365cbb3e5821a891f1e12b70"
    end
    if Hardware::CPU.intel?
      url "https://github.com/blankeos/lazygitrs/releases/download/v0.0.25/lazygitrs-x86_64-apple-darwin.tar.xz"
      sha256 "f6fb98bff1faac674dff816d16d98276d654d58c3fa3979b84d4b155b2e124c8"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/blankeos/lazygitrs/releases/download/v0.0.25/lazygitrs-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d8f310f59580909741196cdcaaa28a5d1fd24a899a34d6394b3970cf70f9d7d2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/blankeos/lazygitrs/releases/download/v0.0.25/lazygitrs-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d9cfc1955d69daa1c22e3689f7e2305da0799a9ac00f80ac7557c8207b47da08"
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
