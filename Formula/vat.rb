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
      url "https://github.com/takealook97/vat/releases/download/v0.8.2/vat_darwin_arm64.tar.gz"
      sha256 "0c6e2154423c10c2fe36f1ebf540ca4422020c8492634ae07ac2c512892c5fdd"
    end
    on_intel do
      url "https://github.com/takealook97/vat/releases/download/v0.8.2/vat_darwin_amd64.tar.gz"
      sha256 "fcc470c689d70db47afb7371f0807e74195babac019d55e37765495727a69191"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/takealook97/vat/releases/download/v0.8.2/vat_linux_arm64.tar.gz"
      sha256 "060a0579a333fe62ec8f9b4f41dcb484ef5988b39dfe0d4d21f5f514d32011e7"
    end
    on_intel do
      url "https://github.com/takealook97/vat/releases/download/v0.8.2/vat_linux_amd64.tar.gz"
      sha256 "c1cb80501ab42fa99176408cf31119ef0673c023d0d290ca326b088a9cfc1aab"
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
