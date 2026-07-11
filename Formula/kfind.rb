class Kfind < Formula
  desc "Fast Korean lemma and inflection search for code and documents"
  homepage "https://github.com/SeokminHong/kfind"
  url "https://github.com/SeokminHong/kfind/releases/download/v0.1.1/kfind-0.1.1.tar.gz"
  sha256 "1304b3cd9509e3d27cfe4ea3594c01af0b609df1d9d331a5728e561c04e3d405"
  license "MIT"

  head "https://github.com/SeokminHong/kfind.git", branch: "main"

  bottle do
    root_url "https://github.com/SeokminHong/homebrew-brew/releases/download/kfind-0.1.1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2e3630401c21a82943aa5bfd0111d5b476344487ff813398672cc2e91f66d839"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2574607b883104129eea17286a69d9bea05effe6ffe0102a77f2a991cab475af"
    sha256 cellar: :any,                 x86_64_linux:  "1acfff8977df79bbab2cfc24173ec0aead6171e6de4317de68f406047ffae2dc"
  end

  depends_on "rust" => :build

  resource "full-pos-lexicon" do
    url "https://github.com/SeokminHong/kfind/releases/download/v0.1.1/kfind-full-pos-0.1.1.tar.gz"
    sha256 "fd4d6a09927c7aa6ebb8a1755bf2a50e9c92c251aa0a18b48436bc17aca452f7"
  end

  resource "distribution-assets" do
    url "https://github.com/SeokminHong/kfind/releases/download/v0.1.1/kfind-assets-0.1.1.tar.gz"
    sha256 "1da1880b64e15bdaa28c6c4897864b5687ba092fa8001ad9e9a9eaadcfe014e1"
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
