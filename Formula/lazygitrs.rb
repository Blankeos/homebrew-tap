class Lazygitrs < Formula
  desc "A faster, memory-safe, more ergonomic slopfork of lazygit"
  homepage "https://github.com/blankeos/lazygitrs"
  version "0.0.38"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/blankeos/lazygitrs/releases/download/v0.0.38/lazygitrs-aarch64-apple-darwin.tar.xz"
      sha256 "7b670d4cfd1f613aa377e5f0dfd5bf12d6a1f08f13823f92cd0325ce314f99db"
    end
    if Hardware::CPU.intel?
      url "https://github.com/blankeos/lazygitrs/releases/download/v0.0.38/lazygitrs-x86_64-apple-darwin.tar.xz"
      sha256 "7cb6957c47e2b1867d7933b7a2bdcd6bd7b2cbc7fac7264527505ee2c4a35796"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/blankeos/lazygitrs/releases/download/v0.0.38/lazygitrs-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "053ad76e53dc2b0d5ea4faf5b8be0644a3d6f49993f7ff69f91ea2217848686c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/blankeos/lazygitrs/releases/download/v0.0.38/lazygitrs-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a96d9f4ce1cfba7b94199fdf7ed603901442b5afcdce0f13ebad9e2a04e80753"
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
