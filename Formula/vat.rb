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
      url "https://github.com/takealook97/vat/releases/download/v0.3.0/vat_darwin_arm64.tar.gz"
      sha256 "a37fab24bb2fa6afcf4aa2700b44bb1f39ecbb2388204e647db18b8d05fce92b"
    end
    on_intel do
      url "https://github.com/takealook97/vat/releases/download/v0.3.0/vat_darwin_amd64.tar.gz"
      sha256 "a7f48f3d8eec2e250401ab4e5f017423fecd083f2a21e9975bd4dac83275d6ad"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/takealook97/vat/releases/download/v0.3.0/vat_linux_arm64.tar.gz"
      sha256 "0bf3d2a0d0ef1ebe44c97071ba669f7de565c1644654ba4400fc6ad47b2ba74e"
    end
    on_intel do
      url "https://github.com/takealook97/vat/releases/download/v0.3.0/vat_linux_amd64.tar.gz"
      sha256 "612e8b545a620810594c2d5da2fb3ee023435715778c7b00aecf423a9a3e57e3"
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
