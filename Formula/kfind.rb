class Kfind < Formula
  desc "Fast Korean lemma and inflection search for code and documents"
  homepage "https://github.com/SeokminHong/kfind"
  url "https://github.com/SeokminHong/kfind/releases/download/v0.1.0/kfind-0.1.0.tar.gz"
  sha256 "6469aa3b38042da1e29118dc464d7afa27e1604ef18d01b4d22634c05f069a56"
  license "MIT"

  head "https://github.com/SeokminHong/kfind.git", branch: "main"

  bottle do
    root_url "https://github.com/SeokminHong/homebrew-brew/releases/download/kfind-0.1.0"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d902fea9f330c7c9d2bd79105a49bee7b02f678a770af391deaae413b0f1df6d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c81bbabeaec367cce77de09c8729ac679a6b496f78ad82975c36ae1d83d102f"
    sha256 cellar: :any,                 x86_64_linux:  "bbfab690b36304bd8c3657d17e7a3da2cd255769fef673b64f77edc01b9eea6a"
  end

  depends_on "rust" => :build

  resource "full-pos-lexicon" do
    url "https://github.com/SeokminHong/kfind/releases/download/v0.1.0/kfind-full-pos-0.1.0.tar.gz"
    sha256 "47cf4e88299d94f3bfe662db9f0cf21d5b0c89594b124acc7e0eef2a87820380"
  end

  resource "distribution-assets" do
    url "https://github.com/SeokminHong/kfind/releases/download/v0.1.0/kfind-assets-0.1.0.tar.gz"
    sha256 "36d32be886af30344fab5bc2f013cccab975a044abefa4d0103ae518fe7b98e9"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/kfind-cli")

    resource("full-pos-lexicon").stage do
      pkgshare.install "lexicon.bin", "MANIFEST.toml"
      (share/"doc/kfind/LICENSES").install "LICENSES/mecab-ko-dic-COPYING"
    end

    resource("distribution-assets").stage do
      man1.install "man/man1/kfind.1"
      bash_completion.install "completions/kfind.bash" => "kfind"
      zsh_completion.install "completions/_kfind"
      fish_completion.install "completions/kfind.fish"
    end

    (share/"doc/kfind/LICENSES").install Dir["LICENSE*"]
  end

  test do
    sample = testpath/"sample.txt"
    sample.write("아주 예쁜 길을 걸어 갔다.\n")

    assert_match "걸어", shell_output("#{bin}/kfind 걷다 #{sample}")
    explain = shell_output("#{bin}/kfind 아주 #{sample} --explain-query")
    assert_match "source: full-pos-lexicon", explain
    refute_match "full POS lexicon unavailable", explain
  end
end
