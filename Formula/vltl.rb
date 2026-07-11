class Vltl < Formula
  desc "Fix a 2-set Korean typo to English"
  homepage "https://github.com/SeokminHong/vltl"
  url "https://github.com/SeokminHong/vltl/archive/refs/tags/v0.2.2.tar.gz"
  sha256 "97dea567bb2437da7f50a54900af1711df112c785cc2bf6a9629f4e76881b57f"
  license "MIT"

  head "https://github.com/SeokminHong/vltl.git", branch: "main"

  bottle do
    root_url "https://github.com/SeokminHong/homebrew-brew/releases/download/vltl-0.2.2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "033af025733c1c5ac5c9433feb4097301b24498d4ae0c2d9ec1c0680d93d89f3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7744ae006ea55bebb99e3a4d015208d8aaca2a763cd50aabdfbdddcb9bf0f96b"
    sha256 cellar: :any,                 x86_64_linux:  "3cecd3af4629c7f42fa5da3659c010720251f70252933d1ec8cb47af2e22198d"
  end

  depends_on "rust" => :build
  depends_on "fish"

  def install
    system "cargo", "install", "vltl", *std_cargo_args
  end

  test do
    assert_match "vltl 0.2.2", shell_output("#{bin}/vltl --version")
  end
end
