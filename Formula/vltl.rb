class Vltl < Formula
  desc "Fix a 2-set Korean typo to English"
  homepage "https://github.com/SeokminHong/vltl"
  url "https://github.com/SeokminHong/vltl/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "a8f53cb9ef3e26c996e6de3c1ba078b8694de4b23ae5c2790dcfde2541d85677"
  license "MIT"

  head "https://github.com/SeokminHong/vltl.git", branch: "main"

  depends_on "rust" => :build
  depends_on "fish"

  def install
    system "cargo", "install", "vltl", *std_cargo_args
  end

  test do
    assert_match "vltl 0.1.2", shell_output("#{bin}/vltl --version")
  end
end
