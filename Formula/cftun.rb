class Cftun < Formula
  desc "A tiny Rust CLI that turns Cloudflare Tunnel into a free, persistent ngrok alternative for webhooks."
  homepage "https://github.com/blankeos/cftun"
  version "0.0.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/blankeos/cftun/releases/download/v0.0.1/cftun-aarch64-apple-darwin.tar.xz"
      sha256 "0b59b7bf8c26080eb3b3bf7fb23746b0a96d1a8d3379adcd50375f910beebcf3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/blankeos/cftun/releases/download/v0.0.1/cftun-x86_64-apple-darwin.tar.xz"
      sha256 "ed1998545fc59dd5b70d453b10016e0712fa9994cc11655480fb963365bfd096"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/blankeos/cftun/releases/download/v0.0.1/cftun-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "838e2d5e91851ad549472459f7dc1e9c1c991838ceac7b55940c2381c5c1152d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/blankeos/cftun/releases/download/v0.0.1/cftun-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "95bc51b095b8b9064ad9e3b201b8e091c389130bb1f48b70e30369ff08d7c14b"
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
