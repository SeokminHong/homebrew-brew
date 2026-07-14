class Kfind < Formula
  desc "Fast Korean lemma and inflection search for code and documents"
  homepage "https://github.com/SeokminHong/kfind"
  url "https://github.com/SeokminHong/kfind/releases/download/v0.2.0/kfind-0.2.0.tar.gz"
  sha256 "7f83807628ab461a8f05d543aa17f982f0dbdfc971101b83a42c7762d7451912"
  license "MIT"

  head "https://github.com/SeokminHong/kfind.git", branch: "main"

  depends_on "rust" => :build

  resource "full-pos-lexicon" do
    url "https://github.com/SeokminHong/kfind/releases/download/v0.2.0/kfind-full-pos-0.2.0.tar.gz"
    sha256 "937e27b2068dd8aa38e06af264bea726c9d6b2d8b66f2135a6445f84a526a388"
  end

  resource "component-resource" do
    url "https://github.com/SeokminHong/kfind/releases/download/v0.2.0/kfind-component-0.2.0.tar.gz"
    sha256 "4f9897fdc5ccb031bb1c370b119b3be6b422510dffb13d55079f317fafd1ac47"
  end

  resource "distribution-assets" do
    url "https://github.com/SeokminHong/kfind/releases/download/v0.2.0/kfind-assets-0.2.0.tar.gz"
    sha256 "b06dfafecce0cbb140c0a4e88d5c3996da12d182ede3a3ed5e2fcce0deefa8ac"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/kfind-cli")

    resource("full-pos-lexicon").stage do
      pkgshare.install "lexicon.bin", "MANIFEST.toml"
      (share/"doc/kfind/LICENSES").install "LICENSES/mecab-ko-dic-COPYING"
    end

    resource("component-resource").stage do
      pkgshare.install "morphology-component-compact.kfc"
      pkgshare.install "MANIFEST.toml" => "component-MANIFEST.toml"
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
    agent = shell_output("#{bin}/kfind --embedded --boundary any --pos verb --json 걷다 #{sample}")
    assert_match '"text":"아주 예쁜 길을 걸어 갔다.\\n"', agent
    explain = shell_output("#{bin}/kfind 아주 #{sample} --explain-query")
    assert_match "source: full-pos-lexicon", explain
    refute_match "full POS lexicon unavailable", explain

    component = testpath/"component.txt"
    component.write("사용자권한을 확인했다.\n대학교를 방문했다.\n")
    assert_match "사용자권한", shell_output("#{bin}/kfind 권한 #{component}")
    assert_empty shell_output("#{bin}/kfind 학교 #{component}", 1)
  end
end
