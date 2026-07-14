class Kfind < Formula
  desc "Fast Korean lemma and inflection search for code and documents"
  homepage "https://github.com/SeokminHong/kfind"
  url "https://github.com/SeokminHong/kfind/releases/download/v0.3.0-rc.2/kfind-0.3.0-rc.2.tar.gz"
  sha256 "a515c0b26bd2f99aa753ed44f21117d60aec1b579f9d2c2b818d16b9b257a7ef"
  license "MIT"

  head "https://github.com/SeokminHong/kfind.git", branch: "main"

  depends_on "rust" => :build

  resource "full-pos-lexicon" do
    url "https://github.com/SeokminHong/kfind/releases/download/v0.3.0-rc.2/kfind-full-pos-0.3.0-rc.2.tar.gz"
    sha256 "937e27b2068dd8aa38e06af264bea726c9d6b2d8b66f2135a6445f84a526a388"
  end

  resource "component-resource" do
    url "https://github.com/SeokminHong/kfind/releases/download/v0.3.0-rc.2/kfind-component-0.3.0-rc.2.tar.gz"
    sha256 "4f9897fdc5ccb031bb1c370b119b3be6b422510dffb13d55079f317fafd1ac47"
  end

  resource "distribution-assets" do
    url "https://github.com/SeokminHong/kfind/releases/download/v0.3.0-rc.2/kfind-assets-0.3.0-rc.2.tar.gz"
    sha256 "5381690bd2d44d9dc894fc30ff7208a6d9f4a5608dd38f1183664433ada139b4"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/kfind-cli")
    pkgshare.install "data/enriched/predicates.tsv" => "predicates.enriched.tsv"
    (share/"doc/kfind/LICENSES").install "data/enriched/NOTICE.md" => "NIKL-enriched-predicates.md"

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
      pkgshare.install "skills"
    end

    (share/"doc/kfind/LICENSES").install Dir["LICENSE*"]
  end

  test do
    sample = testpath/"sample.txt"
    sample.write("아주 예쁜 길을 걸어 갔다.\n")

    assert_match "걸어", shell_output("#{bin}/kfind 걷다 #{sample}")
    agent = shell_output("#{bin}/kfind --embedded --boundary any --pos verb --json 걷다 #{sample}")
    assert_match '"text":"아주 예쁜 길을 걸어 갔다."', agent
    explain = shell_output("#{bin}/kfind 아주 #{sample} --explain-query")
    assert_match "source: full-pos-lexicon", explain
    refute_match "full POS lexicon unavailable", explain

    irregular = testpath/"irregular.txt"
    irregular.write("선을 갈라 두었다.\n")
    assert_match "갈라", shell_output("#{bin}/kfind --boundary any --pos verb 가르다 #{irregular}")

    component = testpath/"component.txt"
    component.write("사용자권한을 확인했다.\n대학교를 방문했다.\n")
    assert_match "사용자권한", shell_output("#{bin}/kfind 권한 #{component}")
    assert_empty shell_output("#{bin}/kfind 학교 #{component}", 1)

    assert_predicate pkgshare/"skills/kfind/SKILL.md", :file?
    assert_predicate pkgshare/"predicates.enriched.tsv", :file?
    assert_match "name: kfind", shell_output("#{bin}/kfind --init --agent custom")
    system bin/"kfind", "--init", "--agent", "codex"
    installed_skill = testpath/".agents/skills/kfind/SKILL.md"
    assert_predicate installed_skill, :symlink?
    assert_equal (opt_pkgshare/"skills/kfind/SKILL.md").realpath, installed_skill.realpath
  end
end
