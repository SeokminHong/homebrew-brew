class Mystats < Formula
  desc "Lightweight Apple Silicon menu bar monitor for macOS"
  homepage "https://github.com/SeokminHong/mystats"
  url "https://github.com/SeokminHong/mystats/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "282546b3af8ee55f083766aff7ded32ce8209eafeff4118b116e0d5dd9f78757"
  license "MIT"

  head "https://github.com/SeokminHong/mystats.git", branch: "main"

  depends_on xcode: ["15.0", :build]
  depends_on arch: :arm64
  depends_on macos: :ventura

  def install
    system "swift", "build", "-c", "release", "--disable-sandbox"

    app_bundle = prefix/"mystats.app"
    app_contents = app_bundle/"Contents"
    app_macos = app_contents/"MacOS"
    app_resources = app_contents/"Resources"

    app_macos.install ".build/release/mystats"
    app_resources.mkpath
    system "swift", "script/generate_app_icon.swift", (app_resources/"AppIcon.icns").to_s

    (app_contents/"Info.plist").write <<~XML
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>CFBundleExecutable</key>
        <string>mystats</string>
        <key>CFBundleIdentifier</key>
        <string>com.seokmin.mystats</string>
        <key>CFBundleName</key>
        <string>mystats</string>
        <key>CFBundleDisplayName</key>
        <string>mystats</string>
        <key>CFBundleIconFile</key>
        <string>AppIcon</string>
        <key>CFBundlePackageType</key>
        <string>APPL</string>
        <key>CFBundleShortVersionString</key>
        <string>#{version}</string>
        <key>CFBundleVersion</key>
        <string>1</string>
        <key>LSMinimumSystemVersion</key>
        <string>13.0</string>
        <key>LSUIElement</key>
        <true/>
        <key>NSPrincipalClass</key>
        <string>NSApplication</string>
      </dict>
      </plist>
    XML

    (bin/"mystats").write <<~SH
      #!/bin/bash
      if [[ "$1" == "--version" || "$1" == "--help" || "$1" == "-h" ]]; then
        exec "#{app_macos}/mystats" "$@"
      fi

      exec /usr/bin/open -n "#{app_bundle}" --args "$@"
    SH
    chmod 0755, bin/"mystats"
  end

  test do
    assert_match "mystats 0.2.0", shell_output("#{bin}/mystats --version")
    assert_path_exists prefix/"mystats.app/Contents/MacOS/mystats"
    assert_path_exists prefix/"mystats.app/Contents/Info.plist"
  end
end
