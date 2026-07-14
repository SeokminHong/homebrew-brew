class Kfind < Formula
  desc "Fast Korean lemma and inflection search for code and documents"
  homepage "https://github.com/SeokminHong/kfind"
  url "https://github.com/SeokminHong/kfind/releases/download/v0.2.1/kfind-0.2.1.tar.gz"
  sha256 "4de6ffb13e000560abf5ca61a4301fdeeed1c7359d7f0c1ab1586898056035c1"
  license "MIT"

  head "https://github.com/SeokminHong/kfind.git", branch: "main"

  bottle do
    root_url "https://github.com/SeokminHong/homebrew-brew/releases/download/kfind-0.2.1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a06f0f5008cf52bf85fc2f66334ba25df75a5b7e4480932af9425cc1493103ff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "05f94d18fd5686b76be4dac061c7c0fbb65102281608967fdb902157e327d5b8"
    sha256 cellar: :any,                 x86_64_linux:  "a78d2723b76aad7a20c7e85a0dc0abd2ffd03b2c418549058a133bc7dc3cff06"
  end

  depends_on "rust" => :build

  resource "full-pos-lexicon" do
    url "https://github.com/SeokminHong/kfind/releases/download/v0.2.1/kfind-full-pos-0.2.1.tar.gz"
    sha256 "937e27b2068dd8aa38e06af264bea726c9d6b2d8b66f2135a6445f84a526a388"
  end

  resource "component-resource" do
    url "https://github.com/SeokminHong/kfind/releases/download/v0.2.1/kfind-component-0.2.1.tar.gz"
    sha256 "4f9897fdc5ccb031bb1c370b119b3be6b422510dffb13d55079f317fafd1ac47"
  end

  resource "distribution-assets" do
    url "https://github.com/SeokminHong/kfind/releases/download/v0.2.1/kfind-assets-0.2.1.tar.gz"
    sha256 "a304daf226086489f3a33abe5fe53e1e0a751a6b658a5e9e784ee826128a6098"
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

    component = testpath/"component.txt"
    component.write("사용자권한을 확인했다.\n대학교를 방문했다.\n")
    assert_match "사용자권한", shell_output("#{bin}/kfind 권한 #{component}")
    assert_empty shell_output("#{bin}/kfind 학교 #{component}", 1)

    assert_predicate pkgshare/"skills/kfind/SKILL.md", :file?
    assert_match "name: kfind", shell_output("#{bin}/kfind --init --agent custom")
    system bin/"kfind", "--init", "--agent", "codex"
    installed_skill = testpath/".agents/skills/kfind/SKILL.md"
    assert_predicate installed_skill, :symlink?
    assert_equal (opt_pkgshare/"skills/kfind/SKILL.md").realpath, installed_skill.realpath
  end
end
