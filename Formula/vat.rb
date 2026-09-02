# A control plane for multi-repo workspaces.
#
# Checksums come from the checksums.txt published with each release. Bump the
# version and all four digests together; a partial bump installs one platform
# from a release the others are not from.
class Vat < Formula
  desc "Control plane for multi-repo workspaces, with a knowledge layer that expires"
  homepage "https://github.com/takealook97/vat"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/takealook97/vat/releases/download/v0.5.1/vat_darwin_arm64.tar.gz"
      sha256 "2c00d6148ae283c2aa526f36f95d2e245b09a6c6d08d5a5690c4a27d0d882f66"
    end
    on_intel do
      url "https://github.com/takealook97/vat/releases/download/v0.5.1/vat_darwin_amd64.tar.gz"
      sha256 "4e903d8f98126db996b96ec1cc9c69a9afe9121fc768c77686d0ae9f89624ef0"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/takealook97/vat/releases/download/v0.5.1/vat_linux_arm64.tar.gz"
      sha256 "21e667bac5f89f7f3c1162af4165f09b4f82b98795d2f3aa582b832c6f13ffed"
    end
    on_intel do
      url "https://github.com/takealook97/vat/releases/download/v0.5.1/vat_linux_amd64.tar.gz"
      sha256 "b0765e614782e3a95e09416238f406f20433c5559ca4dbf69f69b3163662f32e"
    end
  end

  def install
    bin.install "vat"
    bash_completion.install "completions/vat.bash" => "vat"
    zsh_completion.install "completions/_vat"
    fish_completion.install "completions/vat.fish"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vat version")

    # `init` is the one command that writes, so the test exercises a real
    # workspace rather than only checking that the binary runs.
    (testpath/"payments").mkpath
    system "git", "-C", testpath/"payments", "init", "--quiet"
    system bin/"vat", "init", "--name", "acme", "--adopt"
    assert_path_exists testpath/"vat.yaml"
    assert_match "acme", (testpath/"vat.yaml").read
  end
end
