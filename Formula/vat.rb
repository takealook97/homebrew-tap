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
      url "https://github.com/takealook97/vat/releases/download/v0.6.4/vat_darwin_arm64.tar.gz"
      sha256 "d135d70a99b1d6d5152641633e8430d1e7c0eedeff691cdf58c2124686e41bef"
    end
    on_intel do
      url "https://github.com/takealook97/vat/releases/download/v0.6.4/vat_darwin_amd64.tar.gz"
      sha256 "0d73bb8c3a0e059745cdfd6ebe14f91e6c81dc79bc555c0992e76d6d00c20b45"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/takealook97/vat/releases/download/v0.6.4/vat_linux_arm64.tar.gz"
      sha256 "bf92a744c9611e818aa4d4130f5eb62c41c0df16590f47d735ddee8be5e56aa0"
    end
    on_intel do
      url "https://github.com/takealook97/vat/releases/download/v0.6.4/vat_linux_amd64.tar.gz"
      sha256 "57bffc053761b2cbcd0922f73a816a74d929ec0b1d9a4624d01402db4744f4e9"
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
