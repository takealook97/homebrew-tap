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
      url "https://github.com/takealook97/vat/releases/download/v0.2.1/vat_darwin_arm64.tar.gz"
      sha256 "af1e651c54e70f0f01e3b21f39baa68783547d78d103740dadfd8b7ebe097942"
    end
    on_intel do
      url "https://github.com/takealook97/vat/releases/download/v0.2.1/vat_darwin_amd64.tar.gz"
      sha256 "6ff6bcf231669f0d78590c89f312446c9e0dff61d79d89b82fd5e685b5aa06b0"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/takealook97/vat/releases/download/v0.2.1/vat_linux_arm64.tar.gz"
      sha256 "6bec084833c96565012ac9f71d8e47c63445f02e3f071262452b52ee5fbe2192"
    end
    on_intel do
      url "https://github.com/takealook97/vat/releases/download/v0.2.1/vat_linux_amd64.tar.gz"
      sha256 "98ebd541fe7eee0300c55662d9985f49c0b5ab938c1b8e8e3ccdd5635f6dd3d9"
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
