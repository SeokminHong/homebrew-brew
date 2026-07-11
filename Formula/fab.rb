class Fab < Formula
  desc "Initialize personal Fish abbreviations"
  homepage "https://github.com/SeokminHong/fab"
  url "https://github.com/SeokminHong/fab/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "be45c9959c25eb534b66bf2a6a1a4aa899810a5c51ed79331589985df8bfbbac"
  license "MIT"

  head "https://github.com/SeokminHong/fab.git", branch: "main"

  depends_on "fish"

  def install
    bin.install "bin/fab"
    pkgshare.install "share/fab/abbreviations.fish"
  end

  test do
    assert_match "fab 0.1.0", shell_output("#{bin}/fab --version")
    assert_match "abbr --add vi nvim", shell_output("#{bin}/fab init")
    system "fish", "-n", pkgshare/"abbreviations.fish"
  end
end
