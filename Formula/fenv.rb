class Fenv < Formula
  desc "Environment manager for Fish shell"
  homepage "https://github.com/SeokminHong/fenv"
  url "https://github.com/SeokminHong/fenv/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "1a41b79d3f38a16957ff99d44f32eda70dd09e3e9a337603ca96e9a556a472c0"
  license "MIT"

  head "https://github.com/SeokminHong/fenv.git", branch: "main"

  bottle do
    root_url "https://github.com/SeokminHong/homebrew-brew/releases/download/fenv-0.1.0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe7e7355507a685588daf8464b2ef844f9edc134e2553d9390699314f05ba7ad"
    sha256 cellar: :any_skip_relocation, ventura:       "dfa6005d732d1149ff46d2c5053880a62064b5470dd9a6d146ddf3f05667a5b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "19ecc842e2dd18d70d8911e2424489524c6027bd3fe2e2a206d13c7ea2fe6277"
  end

  depends_on "fish"

  def install
    prefix.install "init.fish"
    bin.install Dir["bin/*"]
  end

  test do
    assert_match "0.1.0", shell_output("#{bin}/fenv version")
  end
end
