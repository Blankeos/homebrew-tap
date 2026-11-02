cask "crabmd" do
  arch arm: "aarch64", intel: "x86_64"

  version "0.0.5"
  sha256 arm:   "c64f4fecc4c03c21d837752888f966e44ceabd58177a5fb64b035a56b393e015",
         intel: "5691e3b20231c1a8317fe30cb442868dfb2944293c8bf97be178bf14716c001f"

  url "https://github.com/Blankeos/crabmd/releases/download/v#{version}/CrabMD-#{arch}-apple-darwin.zip"
  name "CrabMD"
  desc "Fast native GPUI markdown writer"
  homepage "https://github.com/Blankeos/crabmd"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on :macos

  app "CrabMD.app"
  binary "#{appdir}/CrabMD.app/Contents/MacOS/crabmd", target: "crabmd"

  # Structured steps only (legacy postflight Ruby is rejected by brew style,
  # even in third-party taps). The migration below never blindly deletes:
  # the outer guard requires the legacy origin marker, and the shell
  # re-checks path distinction + bundle identity before removing.
  postflight_steps do
    run "/usr/bin/xattr",
        args:         ["-dr", "com.apple.quarantine", "{{appdir}}/CrabMD.app"],
        must_succeed: false
    if_path_exists "Applications/CrabMD.app/Contents/Resources/origin", base: :home do
      run "/bin/sh",
          args:           ["-c", <<~SH],
            legacy="$HOME/Applications/CrabMD.app"
            managed="{{appdir}}/CrabMD.app"
            [ "$legacy" != "$managed" ] || exit 0
            if [ -e "$legacy" ] && [ -e "$managed" ] && [ "$legacy" -ef "$managed" ]; then exit 0; fi
            [ -d "$legacy" ] || exit 0
            [ -f "$legacy/Contents/Info.plist" ] || exit 0
            id=$(/usr/bin/defaults read "$legacy/Contents/Info" CFBundleIdentifier 2>/dev/null || true)
            [ "$id" = "ai.blankeos.crabmd" ] || exit 0
            [ -f "$legacy/Contents/Resources/origin" ] || exit 0
            rm -rf "$legacy"
          SH
          must_succeed:   false,
          writable_paths: ["Applications"],
          writable_base:  :home
    end
  end

  # app + binary artifacts are removed automatically on
  # brew uninstall --cask (managed /Applications copy + CLI shim).
  # Settings in ~/.config/crabmd are retained; use --zap to discard them.
  uninstall quit: "ai.blankeos.crabmd"

  zap trash: [
    "~/.config/crabmd",
    "~/Library/Saved Application State/ai.blankeos.crabmd.savedState",
  ]

  caveats "The Homebrew formula and npm package are retired on macOS."
end
