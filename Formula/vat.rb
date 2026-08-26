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
      sha256 "37c7da3c954ec09b436d2e328e7337010ded85a647a6e9534e961e0327849f1b"
    end
    on_intel do
      url "https://github.com/takealook97/vat/releases/download/v0.1.0/vat_darwin_amd64.tar.gz"
      sha256 "22e8a89d3bb9b8ae4a39ff0c15113d0b30b9a94215f94b03ec9f4f1383b363e0"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/takealook97/vat/releases/download/v0.1.0/vat_linux_arm64.tar.gz"
      sha256 "4959a3f3121840d16d69ffec843c4960ce0fda22e09390a007a919bce4ca31d2"
    end
    on_intel do
      url "https://github.com/takealook97/vat/releases/download/v0.1.0/vat_linux_amd64.tar.gz"
      sha256 "4115568e66161eea3b8a99aa3cd045a465125e65353b5d480e2577a8606b2e69"
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
