class Fenv < Formula
  desc ""
  homepage "https://github.com/SeokminHong/fenv"
  url "https://github.com/SeokminHong/fenv/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "1a41b79d3f38a16957ff99d44f32eda70dd09e3e9a337603ca96e9a556a472c0"
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
