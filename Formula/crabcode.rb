class Crabcode < Formula
  desc "Rust AI CLI Coding Agent with a beautiful terminal UI"
  homepage "https://github.com/blankeos/crabcode"
  version "0.0.9"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/blankeos/crabcode/releases/download/v0.0.9/crabcode-aarch64-apple-darwin.tar.xz"
      sha256 "8af115d28daa0dc64ca5a553507fa8844e2a66e249626064b95cb559c7a2e34e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/blankeos/crabcode/releases/download/v0.0.9/crabcode-x86_64-apple-darwin.tar.xz"
      sha256 "9e0da3891b6925d7c9aedd6bf535a155e0fa2cf7622f51e2391b9964f9925b95"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/blankeos/crabcode/releases/download/v0.0.9/crabcode-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7d554610e8e02a2b157f3cba72dbae40ac73f2d2b86e6a8b943662687940b6d6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/blankeos/crabcode/releases/download/v0.0.9/crabcode-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "bb7e0bd9d8f8aa03e0be1790230a07c788a1bb573b15439b73bad800eae9a9b3"
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
    bin.install "crabcode" if OS.mac? && Hardware::CPU.arm?
    bin.install "crabcode" if OS.mac? && Hardware::CPU.intel?
    bin.install "crabcode" if OS.linux? && Hardware::CPU.arm?
    bin.install "crabcode" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
