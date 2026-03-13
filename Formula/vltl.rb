class Vltl < Formula
  desc "Fix a 2-set Korean typo to English"
  homepage "https://github.com/SeokminHong/vltl"
  url "https://github.com/SeokminHong/vltl/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "94356abbca38e97415b397d1ab8647b97370142c0a40cf11af316980ce9d045f"
  license "MIT"

  head "https://github.com/SeokminHong/vltl.git", branch: "main"

  bottle do
    root_url "https://github.com/SeokminHong/homebrew-brew/releases/download/vltl-0.2.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "370b0ace2c01a4a680bff6599120eb9ab98eba744ee191baebd9a116adc09a7b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c60ece119510d09599c4529a842dea612e88f218f99a55f1abb9fd5199df209"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff6a130e91e152627a49ad96d359427598e45aecaad8e35bd08482e5771cc715"
  end

  depends_on "rust" => :build
  depends_on "fish"

  def install
    system "cargo", "install", "vltl", *std_cargo_args
  end

  test do
    assert_match "vltl 0.2.0", shell_output("#{bin}/vltl --version")
  end
end
