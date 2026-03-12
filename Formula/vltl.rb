class Vltl < Formula
  desc "Fix a 2-set Korean typo to English"
  homepage "https://github.com/SeokminHong/vltl"
  url "https://github.com/SeokminHong/vltl/archive/refs/tags/v0.1.6.tar.gz"
  sha256 "471b3f9896ba89ed91320c73c5bd89060f51cef9ae6735cd63ceb001695ab415"
  license "MIT"

  head "https://github.com/SeokminHong/vltl.git", branch: "main"

  depends_on "rust" => :build
  depends_on "fish"

  def install
    system "cargo", "install", "vltl", *std_cargo_args
  end

  test do
    assert_match "vltl 0.1.6", shell_output("#{bin}/vltl --version")
  end
end
