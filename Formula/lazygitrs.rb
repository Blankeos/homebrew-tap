class Lazygitrs < Formula
  desc "A faster, memory-safe, more ergonomic slopfork of lazygit"
  homepage "https://github.com/blankeos/lazygitrs"
  version "0.0.37"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/blankeos/lazygitrs/releases/download/v0.0.37/lazygitrs-aarch64-apple-darwin.tar.xz"
      sha256 "e2841024c7eb832794dd2c218f71c032c42669d9a39059ec7d1df56f42c54927"
    end
    if Hardware::CPU.intel?
      url "https://github.com/blankeos/lazygitrs/releases/download/v0.0.37/lazygitrs-x86_64-apple-darwin.tar.xz"
      sha256 "515c95c0fffa3972b963abd05486ebea2298b77bea6f17e8997ad6853329a855"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/blankeos/lazygitrs/releases/download/v0.0.37/lazygitrs-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "6ebba61f44b0631ddab34562f62223463705d57ab30731931054c5144f9ed2ac"
    end
    if Hardware::CPU.intel?
      url "https://github.com/blankeos/lazygitrs/releases/download/v0.0.37/lazygitrs-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "0fd6a14937f48c81bf93b07aa89ee008a5f8a46eba7699a27a95811d53200bf3"
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
