class Fenv < Formula
  desc ""
  homepage "https://github.com/SeokminHong/fenv"
  url "https://github.com/SeokminHong/fenv/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "353130208812a2601a7798e789f58d477d0ed7cce9e7399109b5bfd401888a04"
  license ""

  head "https://github.com/SeokminHong/fenv.git", branch: "main"

  depends_on "fish"

  def install
    prefix.install "init.fish"
    bin.install Dir["bin/*"]
  end

  test do
    assert_match "0.1.0", shell_output("#{bin}/fenv version")
  end
end
