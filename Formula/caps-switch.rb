class CapsSwitch < Formula
  desc "Remap Caps Lock to a function key from the macOS menu bar"
  homepage "https://github.com/SeokminHong/caps-switch"
  url "https://github.com/SeokminHong/caps-switch/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "d2ddf25387a4089e711e1f16f6a3e54ab67bd5d8c14dbae3b89d65da74df9444"

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
    assert_path_exists app/"Resources/caps-lock-input-source.png"
    assert_path_exists app/"Resources/input-source-shortcut.png"
    system "/usr/bin/codesign", "--verify", "--strict", (prefix/"Caps Switch.app").to_s
  end
end
