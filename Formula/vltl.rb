class Vltl < Formula
  desc "Fix a 2-set Korean typo to English"
  homepage "https://github.com/SeokminHong/vltl"
  url "https://github.com/SeokminHong/vltl/archive/refs/tags/v0.1.7.tar.gz"
  sha256 "bcd4c73b2e95b751ed3e463cf77b98b681ccb2dd6394300aa3d09f4cf47cc2db"
  license "MIT"

  head "https://github.com/SeokminHong/vltl.git", branch: "main"

  bottle do
    root_url "https://github.com/SeokminHong/homebrew-brew/releases/download/vltl-0.1.7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0172020232e745d7ff2ce42d73c47a8bc3c6773a360e0ca56a9402323ee23e52"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "60217bf07e71ffcc99317732baa67011dc94e86e70698b97dcc73d35a145d206"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d03c16fb613566bbe20d0a8d66485289a840a744bd973878fc866adc48da443"
  end

  depends_on "rust" => :build
  depends_on "fish"

  def install
    system "cargo", "install", "vltl", *std_cargo_args
  end

  test do
    assert_match "vltl 0.1.7", shell_output("#{bin}/vltl --version")
  end
end
