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
      url "https://github.com/takealook97/vat/releases/download/v0.1.6/vat_darwin_arm64.tar.gz"
      sha256 "958d6450a8860840d68454407a10074acd4e85da3eff3865f240555c3ddbdd34"
    end
    on_intel do
      url "https://github.com/takealook97/vat/releases/download/v0.1.6/vat_darwin_amd64.tar.gz"
      sha256 "5bce45f9454b2d8eafceed70157bb4b2fab2596a35fbb639792043b5cefe4fa7"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/takealook97/vat/releases/download/v0.1.6/vat_linux_arm64.tar.gz"
      sha256 "ec9e0d7c5ce4f0108484b0531c38e21c2db6b15b14e5544754d1e40704b100bb"
    end
    on_intel do
      url "https://github.com/takealook97/vat/releases/download/v0.1.6/vat_linux_amd64.tar.gz"
      sha256 "8a5103a1ed08c00386a7697dfd7ec7cf5c2e5593383456bc828c12e7bb6178f8"
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
