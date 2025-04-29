class Fenv < Formula
  desc "Environment manager for Fish shell"
  homepage "https://github.com/SeokminHong/fenv"
  url "https://github.com/SeokminHong/fenv/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "9132a9a58c9bff2414b6d467c1f3fb74f9ecb9b139a11a4b9b7ed8bc62f2777a"
  license "MIT"

  head "https://github.com/SeokminHong/fenv.git", branch: "main"

  bottle do
    root_url "https://github.com/SeokminHong/homebrew-brew/releases/download/fenv-0.2.0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "94bdadfe91a9e78fc93be3f9ded6f3b8222e31a732bb3b162a0d8bdab390f4a6"
    sha256 cellar: :any_skip_relocation, ventura:       "05790a90e65fdb73d38e1f87803a753c2da5b2d8214b23f0e61a6523cd8776c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "31550fa537049fc9da3cc287514a983ce33a0b7d7180d141c6334242479da115"
  end

  depends_on "rust" => :build
  depends_on "fish"

  def install
    system "cargo", "install", "seokmin_fenv", *std_cargo_args
  end

  test do
    assert_match "fenv 0.2.0", shell_output("#{bin}/fenv --version")
  end
end
