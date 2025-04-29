class Fenv < Formula
  desc "Environment manager for Fish shell"
  homepage "https://github.com/SeokminHong/fenv"
  url "https://github.com/SeokminHong/fenv/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "9132a9a58c9bff2414b6d467c1f3fb74f9ecb9b139a11a4b9b7ed8bc62f2777a"
  license "MIT"

  head "https://github.com/SeokminHong/fenv.git", branch: "main"

  depends_on "fish"
  depends_on "rust" => :build

  def install
    system "cargo", "install", "seokmin_fenv", *std_cargo_args
  end

  test do
    assert_match "fenv 0.2.0", shell_output("#{bin}/fenv --version")
  end
end
