class Fab < Formula
  desc "Initialize personal Fish abbreviations"
  homepage "https://github.com/SeokminHong/fab"
  url "https://github.com/SeokminHong/fab/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "754a2d326cc0016ab5f178fedc1324c393531b3203dbcf6b9b293c1c5bcc2a40"
  license "MIT"

  head "https://github.com/SeokminHong/fab.git", branch: "main"

  bottle do
    root_url "https://github.com/SeokminHong/homebrew-brew/releases/download/fab-0.1.1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "45ad88c0ea8344d61e07345f9e7e259be30c04a3e75f4dc0190bf6433bee1ea6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2ab7e9f59e9ddd61caa3a5abedc8a78a4395c9f661535a737478f06269e2b3ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c5d384d1e082b701e3b634d6e6f8ca9f88a0b79b0836ed30422ce20cc477ee00"
  end

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
