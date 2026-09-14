cask "crabmd" do
  arch arm: "aarch64", intel: "x86_64"

  version "0.0.4"
  sha256 arm:   "fa4b36cc79f4ad27d8b6534853d255246c5d27cd96ae97860592e315d9a4bbd3",
         intel: "27e4ad17843c57b194dd192a23b64e8fe7d24096eb362522b2b1cc853b7e3252"

  url "https://github.com/Blankeos/crabmd/releases/download/v#{version}/CrabMD-#{arch}-apple-darwin.zip"
  name "CrabMD"
  desc "Fast native GPUI markdown writer"
  homepage "https://github.com/Blankeos/crabmd"

  livecheck do
    url :url
    strategy :github_latest
  end

  # The retired formula shipped the same crabmd binary without the app
  # bundle. Keep the conflict so brew errors clearly instead of forking app
  # identity (two Dock icons, Spotlight reopen doing nothing).
  conflicts_with formula: "crabmd"
  depends_on macos: :big_sur

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
