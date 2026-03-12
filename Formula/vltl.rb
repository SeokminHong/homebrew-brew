class Vltl < Formula
  desc "Fix a 2-set Korean typo to English"
  homepage "https://github.com/SeokminHong/vltl"
  url "https://github.com/SeokminHong/vltl/archive/refs/tags/v0.1.5.tar.gz"
  sha256 "9b1645d6736a139ccb37b80e9f161f3044ac7905604789468d8b51d71b708382"
  license "MIT"

  head "https://github.com/SeokminHong/vltl.git", branch: "main"

  bottle do
    root_url "https://github.com/SeokminHong/homebrew-brew/releases/download/vltl-0.1.5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ec066e6c68e8430a9d2e9210e2777984f9c514424a26d6ccb995211e65fea4d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b5d5e64519b59c0ca273d36d3335424c31bfb472c9d9bbe505f114234ac49f4"
  end

  depends_on "rust" => :build
  depends_on "fish"

  def install
    system "cargo", "install", "vltl", *std_cargo_args
  end

  test do
    assert_match "vltl 0.1.5", shell_output("#{bin}/vltl --version")
  end
end
