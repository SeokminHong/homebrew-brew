class Vltl < Formula
  desc "Fix a 2-set Korean typo to English"
  homepage "https://github.com/SeokminHong/vltl"
  url "https://github.com/SeokminHong/vltl/archive/refs/tags/v0.1.6.tar.gz"
  sha256 "471b3f9896ba89ed91320c73c5bd89060f51cef9ae6735cd63ceb001695ab415"
  license "MIT"

  head "https://github.com/SeokminHong/vltl.git", branch: "main"

  bottle do
    root_url "https://github.com/SeokminHong/homebrew-brew/releases/download/vltl-0.1.6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "16a768ea3a70ff5875994df80b2f1e960b0b79b85ccb1f30c3ededa2b184e152"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "389edb4529278c9843b2aa1c4d4e7393342bc86124bc56b09be24916d2e94311"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a777903001f7ec8dbdbf94ae4b4e989847cc8fc8565d1d6bd9b4b31b88d64303"
  end

  depends_on "rust" => :build
  depends_on "fish"

  def install
    system "cargo", "install", "vltl", *std_cargo_args
  end

  test do
    assert_match "vltl 0.1.6", shell_output("#{bin}/vltl --version")
  end
end
