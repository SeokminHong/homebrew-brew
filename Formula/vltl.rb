class Vltl < Formula
  desc "Fix a 2-set Korean typo to English"
  homepage "https://github.com/SeokminHong/vltl"
  url "https://github.com/SeokminHong/vltl/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "941adbdfdf9542e3f7ea44c4f4be96f04a79916dc087e871bb6df4ea421ecd23"
  license "MIT"

  head "https://github.com/SeokminHong/vltl.git", branch: "main"

  depends_on "rust" => :build
  depends_on "fish"

  def install
    system "cargo", "install", "vltl", *std_cargo_args
  end

  test do
    assert_match "vltl 0.1.1", shell_output("#{bin}/vltl --version")
  end
end
