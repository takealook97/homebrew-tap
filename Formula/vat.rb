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
      url "https://github.com/takealook97/vat/releases/download/v0.6.3/vat_darwin_arm64.tar.gz"
      sha256 "40de75617339ba9b62cc49967fe395bf0e436daa5d47189a6337691ceb87cf12"
    end
    on_intel do
      url "https://github.com/takealook97/vat/releases/download/v0.6.3/vat_darwin_amd64.tar.gz"
      sha256 "a349af2729a4cddc0a056f125198ab7cbb8a6f385b66d0bc70456930b56df748"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/takealook97/vat/releases/download/v0.6.3/vat_linux_arm64.tar.gz"
      sha256 "510318abdb9a38483334927b983e2fc2a139dd6a829f94c1c60f73d0f85057f4"
    end
    on_intel do
      url "https://github.com/takealook97/vat/releases/download/v0.6.3/vat_linux_amd64.tar.gz"
      sha256 "489c50f4425a78a44f39ec9239ba8f88cdc05df93a70a923ddb9c436a0ecc216"
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
