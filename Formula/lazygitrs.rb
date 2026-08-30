class Lazygitrs < Formula
  desc "A faster, memory-safe, more ergonomic slopfork of lazygit"
  homepage "https://github.com/blankeos/lazygitrs"
  version "0.0.35"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/blankeos/lazygitrs/releases/download/v0.0.35/lazygitrs-aarch64-apple-darwin.tar.xz"
      sha256 "3880ca57ff8396d64cdb33128af66655982d323233092e81455af19457c0d5a9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/blankeos/lazygitrs/releases/download/v0.0.35/lazygitrs-x86_64-apple-darwin.tar.xz"
      sha256 "129766f9d66f21b041f8f4406ff482629565e2927e19ae8f69b024ffa85d8613"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/blankeos/lazygitrs/releases/download/v0.0.35/lazygitrs-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "4fab84f15896550b91c4650abaf4bc718140ea85b1ca01cd2a84ff1c8fdfc416"
    end
    if Hardware::CPU.intel?
      url "https://github.com/blankeos/lazygitrs/releases/download/v0.0.35/lazygitrs-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e66f34b8cc8e77025d74510775d4d835fd7af60c218a87b7afb37399fd0eaeb1"
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
