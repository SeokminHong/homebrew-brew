class Vltl < Formula
  desc "Fix a 2-set Korean typo to English"
  homepage "https://github.com/SeokminHong/vltl"
  url "https://github.com/SeokminHong/vltl/archive/refs/tags/v0.1.5.tar.gz"
  sha256 "9b1645d6736a139ccb37b80e9f161f3044ac7905604789468d8b51d71b708382"
  license "MIT"

  head "https://github.com/SeokminHong/vltl.git", branch: "main"

  bottle do
    root_url "https://github.com/SeokminHong/homebrew-brew/releases/download/vltl-0.1.5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "37188dcd7b4e53a862e9766888909edb7cbd3b74a5e419d7af2e3265eeac0243"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "795ab7895bc16e25aca7850e4f982a8ed3a0c7ff13eb6a29ad0004e95ab4839c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b5182d6b5ead46a33105814ccee39a96debd69e701d518308564b3f4c7b5b3be"
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
