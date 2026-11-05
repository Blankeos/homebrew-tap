class Kondor < Formula
  desc "Find and clear build leftovers (node_modules, target, caches) across all your projects"
  homepage "https://github.com/Blankeos/kondor"
  version "0.1.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Blankeos/kondor/releases/download/v0.1.2/kondor-cli-aarch64-apple-darwin.tar.gz"
      sha256 "b1f9f299028b93642b81f4daab470fa12d40f7603a22a1004f36b8f8e554e744"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Blankeos/kondor/releases/download/v0.1.2/kondor-cli-x86_64-apple-darwin.tar.gz"
      sha256 "adb4c933a395489d87556751702f779ff001860cfbb59b08d340471830240490"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Blankeos/kondor/releases/download/v0.1.2/kondor-cli-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "79ecea6388f65d80332d1b9ce57798e300bcd96daed9b95f41ecac9c03bd0774"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Blankeos/kondor/releases/download/v0.1.2/kondor-cli-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "ce96c080cbf624b0c3071a03fdb95fc233ee2ebeea85713e166a11e6c21f8ae9"
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
      bin.install "kondor"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "kondor"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "kondor"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "kondor"
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
