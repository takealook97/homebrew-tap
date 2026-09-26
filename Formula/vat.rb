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
      url "https://github.com/takealook97/vat/releases/download/v0.6.5/vat_darwin_arm64.tar.gz"
      sha256 "4d25f695e03b37471a1fa5428a9254bc51084f01c8b07dc9ca851ecb056c663a"
    end
    on_intel do
      url "https://github.com/takealook97/vat/releases/download/v0.6.5/vat_darwin_amd64.tar.gz"
      sha256 "4bbf9192d61276c0f1690db42543f244788375e71371191317ef8948bd655345"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/takealook97/vat/releases/download/v0.6.5/vat_linux_arm64.tar.gz"
      sha256 "979345a1a9c9414fa9d182d96944c1fe679af2cca1018d7c470d902ec7ee0d25"
    end
    on_intel do
      url "https://github.com/takealook97/vat/releases/download/v0.6.5/vat_linux_amd64.tar.gz"
      sha256 "d0f59df1e60c8228f75ae4d7772b6589338180ee75cc5f5a382a1bda5dd299d8"
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
