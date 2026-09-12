class Kfind < Formula
  desc "Fast Korean lemma and inflection search for code and documents"
  homepage "https://github.com/SeokminHong/kfind"
  url "https://github.com/SeokminHong/kfind/releases/download/v1.0.1/kfind-1.0.1.tar.gz"
  sha256 "da0faae17b0d0bb0004a1f74282887fc9b2b40ed9a1163449fa32770f0db65f5"
  license :cannot_represent

  bottle do
    root_url "https://github.com/SeokminHong/homebrew-brew/releases/download/kfind-1.0.1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "554cea7052cbca35f421b886dea9434ddc708a0b4c5fa09883497079fc86d2ed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "96387c4c33c9cecaec8dde1a5ed4d4680e24744d7535c4f459c303716ca1a70f"
    sha256 cellar: :any,                 x86_64_linux:  "ef87fcf19f61a5fb2d911687240036cbf7fb6f565a29078363d83dba65e58bfa"
  end

  depends_on "rustup" => :build

  resource "full-pos-lexicon" do
    url "https://github.com/SeokminHong/kfind/releases/download/v1.0.1/kfind-full-pos-1.0.1.tar.gz"
    sha256 "937e27b2068dd8aa38e06af264bea726c9d6b2d8b66f2135a6445f84a526a388"
  end

  resource "component-resource" do
    url "https://github.com/SeokminHong/kfind/releases/download/v1.0.1/kfind-component-1.0.1.tar.gz"
    sha256 "20f844320684fb5d049eaf8ad7bbad21aebdc067ec4a25d296018efb467f30fe"
  end

  resource "distribution-assets" do
    url "https://github.com/SeokminHong/kfind/releases/download/v1.0.1/kfind-assets-1.0.1.tar.gz"
    sha256 "230d85176cfd95267e5ce8d3604c8fe93e27d049dcf41b6399db47863a333007"
  end

  def install
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "1.97.0"
    system "cargo", "install", *std_cargo_args(path: "crates/kfind-cli")
    pkgshare.install "data/enriched/predicates.tsv" => "predicates.enriched.tsv"
    (share/"doc/kfind/LICENSES").install "data/enriched/NOTICE.md" => "NIKL-derived-data.md"

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

  post_install_steps do
    run "kfind", args: ["--check-data", "--data-dir", "{{pkgshare}}"], base: :bin, print_stdout: true
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
    assert_match "대학교를 방문했다.", shell_output("#{bin}/kfind 학교 #{component}")
    data_check = shell_output("#{bin}/kfind --check-data --json --data-dir #{pkgshare}")
    assert_match '"status":"ok"', data_check
    assert_match '"resource_version":"1.0.1"', data_check

    assert_predicate pkgshare/"skills/kfind/SKILL.md", :file?
    assert_predicate pkgshare/"predicates.enriched.tsv", :file?
    assert_predicate opt_share/"doc/kfind/LICENSES/NIKL-derived-data.md", :file?
    assert_match "name: kfind", shell_output("#{bin}/kfind --init --agent custom")
    system bin/"kfind", "--init", "--agent", "codex"
    installed_skill = testpath/".agents/skills/kfind/SKILL.md"
    assert_predicate installed_skill, :symlink?
    assert_equal (opt_pkgshare/"skills/kfind/SKILL.md").realpath, installed_skill.realpath
  end
end
