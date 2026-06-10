class Crabcode < Formula
  desc "(WIP) Rust AI CLI Coding Agent with a beautiful terminal UI"
  homepage "https://github.com/blankeos/crabcode"
  version "0.0.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/blankeos/crabcode/releases/download/v0.0.3/crabcode-aarch64-apple-darwin.tar.xz"
      sha256 "daccc4e7d476d8f42a2b0bf5d100aca4c41af8c4dd83845de167698aa62543dd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/blankeos/crabcode/releases/download/v0.0.3/crabcode-x86_64-apple-darwin.tar.xz"
      sha256 "59503908b8cef432e06a6d50faf13014186b5a37d005ea132fc46afc5454711c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/blankeos/crabcode/releases/download/v0.0.3/crabcode-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "79e9cc51d97bcc86ac68dcdc4c537379a9236815686f324fe85c1b4a9ba82686"
    end
    if Hardware::CPU.intel?
      url "https://github.com/blankeos/crabcode/releases/download/v0.0.3/crabcode-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "27f4b4043308e9393e762cb148a4e5734171f6912fe42bc8fef74c2f76563665"
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
