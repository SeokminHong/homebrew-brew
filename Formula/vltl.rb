class Vltl < Formula
  desc "Fix a 2-set Korean typo to English"
  homepage "https://github.com/SeokminHong/vltl"
  url "https://github.com/SeokminHong/vltl/archive/refs/tags/v0.1.3.tar.gz"
  sha256 "4cc77a30a5c699f246833e171e868396cb634f0b53ad9e9e8e646c768e6ef545"
  license "MIT"

  head "https://github.com/SeokminHong/vltl.git", branch: "main"

  bottle do
    root_url "https://github.com/SeokminHong/homebrew-brew/releases/download/vltl-0.1.3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "65063088a03fdbbdea07fb2785c27339613a1bddf082f7f0597fb0b0981d147d"
    sha256 cellar: :any_skip_relocation, ventura:       "af73867a4811655a99194e087b12abe1a120fb35b9c9f1b13ef682e17901f8cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cfdcc9f68fe8855c79e55c74387b7a46846d23c4edc47c13bc5470399166b242"
  end

  depends_on "rust" => :build
  depends_on "fish"

  def install
    system "cargo", "install", "vltl", *std_cargo_args
  end

  test do
    assert_match "vltl 0.1.3", shell_output("#{bin}/vltl --version")
  end
end
