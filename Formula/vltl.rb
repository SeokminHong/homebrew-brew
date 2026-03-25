class Vltl < Formula
  desc "Fix a 2-set Korean typo to English"
  homepage "https://github.com/SeokminHong/vltl"
  url "https://github.com/SeokminHong/vltl/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "e3d5121a4ccaedde56d414f8e0a257489a550ca04718daac432ec3abfdda5350"
  license "MIT"

  head "https://github.com/SeokminHong/vltl.git", branch: "main"

  bottle do
    root_url "https://github.com/SeokminHong/homebrew-brew/releases/download/vltl-0.2.1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8c977a10e0483665dd6cc42083cb88bfcd074868e8b8e2a29c3b923ee2e547cf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f20eff0a9bdde3915598b830d8e2185667ba71668d35a46fb0e330160852e779"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "004ea3b90c31ad42d744f902bb7300b2893048c54ecb204f40a479668937c567"
  end

  depends_on "rust" => :build
  depends_on "fish"

  def install
    system "cargo", "install", "vltl", *std_cargo_args
  end

  test do
    assert_match "vltl 0.2.1", shell_output("#{bin}/vltl --version")
  end
end
