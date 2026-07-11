class Fab < Formula
  desc "Initialize personal Fish abbreviations"
  homepage "https://github.com/SeokminHong/fab"
  url "https://github.com/SeokminHong/fab/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "be45c9959c25eb534b66bf2a6a1a4aa899810a5c51ed79331589985df8bfbbac"
  license "MIT"

  head "https://github.com/SeokminHong/fab.git", branch: "main"

  bottle do
    root_url "https://github.com/SeokminHong/homebrew-brew/releases/download/fab-0.1.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b2293173ae9b29aad1995615d06fbff3ee3c4bc082185de51e778bf18b2756e4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e9e20a41a0072abaa18632fedbb3ad93365bcdc2da9d89d2e5026e98fbc61143"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "03223b2fd2288761c605cce5fe9528c88a308f74cbb57907598ea3c4abb2b6e1"
  end

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
