class CapsSwitch < Formula
  desc "Switch input sources with Caps Lock from the macOS menu bar"
  homepage "https://github.com/SeokminHong/caps-switch"
  url "https://github.com/SeokminHong/caps-switch/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "7204aad7acacf195cd2daf2063c75bdf8f8b24dc121961b131e74c4ccbb34c7f"

  bottle do
    root_url "https://github.com/SeokminHong/homebrew-brew/releases/download/caps-switch-1.1.1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c141c2d9b382e1be24b4f932f0fb57d5cb545d94e807c5819ba28b3ee7868dec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c7cffb5a1c9b8e3a6faab6956b44d486ea76b6a8e0e4cec0bfea0d524e536d81"
    sha256 cellar: :any_skip_relocation, sequoia:       "a24ca8bea9e5afccf6c042e18a0ce1188b26eb60ae28950aee3c4e539b60f4b4"
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
