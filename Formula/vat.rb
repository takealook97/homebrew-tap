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
      url "https://github.com/takealook97/vat/releases/download/v0.1.0/vat_darwin_arm64.tar.gz"
      sha256 "b213b16c1bea9753814b8b4ecd7e012df2dde3b261691b07fba41241a710606f"
    end
    on_intel do
      url "https://github.com/takealook97/vat/releases/download/v0.1.0/vat_darwin_amd64.tar.gz"
      sha256 "1d623bfdb3b658f8dcbb213f275bce96c0f787749ce988b1ec2d489838e2609f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/takealook97/vat/releases/download/v0.1.0/vat_linux_arm64.tar.gz"
      sha256 "67275a296648ca4fed38f3d8f3fa10e24b4a46c832e9b7f5174772f990cd26de"
    end
    on_intel do
      url "https://github.com/takealook97/vat/releases/download/v0.1.0/vat_linux_amd64.tar.gz"
      sha256 "2499018ff399679b248c8fa48ef04e60d21ee11d680b72c82e8e3a62dac3d906"
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
