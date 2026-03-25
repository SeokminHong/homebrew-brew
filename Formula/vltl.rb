class Vltl < Formula
  desc "Fix a 2-set Korean typo to English"
  homepage "https://github.com/SeokminHong/vltl"
  url "https://github.com/SeokminHong/vltl/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "e3d5121a4ccaedde56d414f8e0a257489a550ca04718daac432ec3abfdda5350"
  license "MIT"

  head "https://github.com/SeokminHong/vltl.git", branch: "main"

  depends_on "rust" => :build
  depends_on "fish"

  def install
    system "cargo", "install", "vltl", *std_cargo_args
  end

  test do
    assert_match "vltl 0.2.1", shell_output("#{bin}/vltl --version")
  end
end
