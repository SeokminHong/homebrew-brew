class Fenv < Formula
  desc "Environment manager for Fish shell"
  homepage "https://github.com/SeokminHong/fenv"
  url "https://github.com/SeokminHong/fenv/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "2860cd9b5c87a3238bba85660298ab3ce67b206b4a0f95d89f40ef7c6a050075"
  license "MIT"

  head "https://github.com/SeokminHong/fenv.git", branch: "main"

  depends_on "rust" => :build
  depends_on "fish"

  def install
    system "cargo", "install", "seokmin_fenv", *std_cargo_args
  end

  test do
    assert_match "fenv 0.2.1", shell_output("#{bin}/fenv --version")
  end
end
