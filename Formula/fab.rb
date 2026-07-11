class Fab < Formula
  desc "Initialize personal Fish abbreviations"
  homepage "https://github.com/SeokminHong/fab"
  url "https://github.com/SeokminHong/fab/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "754a2d326cc0016ab5f178fedc1324c393531b3203dbcf6b9b293c1c5bcc2a40"
  license "MIT"

  head "https://github.com/SeokminHong/fab.git", branch: "main"

  depends_on "fish"

  def install
    bin.install "bin/fab"
    pkgshare.install "share/fab/abbreviations.fish"
  end

  test do
    assert_match "fab 0.1.1", shell_output("#{bin}/fab --version")
    assert_match "abbr --add vi nvim", shell_output("#{bin}/fab init")
    system "fish", "-n", pkgshare/"abbreviations.fish"
  end
end
