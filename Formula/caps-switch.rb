class CapsSwitch < Formula
  desc "Switch input sources with Caps Lock from the macOS menu bar"
  homepage "https://github.com/SeokminHong/caps-switch"
  url "https://github.com/SeokminHong/caps-switch/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "11bc19b482edd301bd4ac4599a9dc108424bea64398a2fc3c0f68c9dddcdf581"

  bottle do
    root_url "https://github.com/SeokminHong/homebrew-brew/releases/download/caps-switch-1.1.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1b6a859c87237779661972d71ab26f9c71500b421ae3a1e80a7cb3cd570abbd8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0bcf7968417057dd324416f616322c320a9a4594a70ed2a7758db98cb3396cc3"
    sha256 cellar: :any_skip_relocation, sequoia:       "656ad86b7f2f16026615af558adbb2d0136246c6eefae159763770331734cfea"
  end

  depends_on xcode: ["16.0", :build]
  depends_on macos: :sonoma

  def install
    system "zsh", "scripts/build-app.sh", "--disable-sandbox"
    prefix.install "build/Caps Switch.app"
  end

  def caveats
    <<~EOS
      To launch Caps Switch:
        open "#{opt_prefix}/Caps Switch.app"

      To make it available in Finder:
        mkdir -p ~/Applications
        ln -s "#{opt_prefix}/Caps Switch.app" ~/Applications/
    EOS
  end

  test do
    app = prefix/"Caps Switch.app/Contents"
    assert_match "caps-switch #{version}", shell_output("\"#{app}/MacOS/CapsSwitch\" --version")
    assert_path_exists app/"Info.plist"
    system "/usr/bin/codesign", "--verify", "--strict", (prefix/"Caps Switch.app").to_s
  end
end
