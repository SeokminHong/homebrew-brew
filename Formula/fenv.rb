class Fenv < Formula
  desc ""
  homepage "https://github.com/SeokminHong/fenv"
  url "https://github.com/SeokminHong/fenv/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "3743309b7bfda5db889ec71d0c3c8d248dd23e985cbb4d8ffdc74e36cc8fba38"
  license ""

  head "https://github.com/SeokminHong/fenv.git", branch: "main"

  def install
    prefix.install "fenv.fish"
  end

  test do
  end
end
