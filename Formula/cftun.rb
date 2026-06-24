class Cftun < Formula
  desc "A tiny Rust CLI that turns Cloudflare Tunnel into a free, persistent ngrok alternative for webhooks."
  homepage "https://github.com/blankeos/cftun"
  version "0.0.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/blankeos/cftun/releases/download/v0.0.2/cftun-aarch64-apple-darwin.tar.xz"
      sha256 "52ba0b45a5f20bea600f3af787bb51269ce9d5e0307f957307d75723e6e4830d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/blankeos/cftun/releases/download/v0.0.2/cftun-x86_64-apple-darwin.tar.xz"
      sha256 "3c57be8bdd2db9d94edc7f0bbfd9171aacacbb92ab73b215bc9b51a38698384d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/blankeos/cftun/releases/download/v0.0.2/cftun-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "3ff5b897659c5a9c986473e14b1ff1131a9b5264d0fa7f534cb5aec0ea0d52e0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/blankeos/cftun/releases/download/v0.0.2/cftun-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "effedac59df347b62ee6aa1b8b21efe4fa00e64048130b7957828e29805cc838"
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
    bin.install "cftun" if OS.mac? && Hardware::CPU.arm?
    bin.install "cftun" if OS.mac? && Hardware::CPU.intel?
    bin.install "cftun" if OS.linux? && Hardware::CPU.arm?
    bin.install "cftun" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
