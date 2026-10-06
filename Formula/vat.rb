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
      url "https://github.com/takealook97/vat/releases/download/v0.7.0/vat_darwin_arm64.tar.gz"
      sha256 "84392fa6637b6608fdf28cfeb9029b07ff7e2529ead1ea3df50b6d47902d69dc"
    end
    on_intel do
      url "https://github.com/takealook97/vat/releases/download/v0.7.0/vat_darwin_amd64.tar.gz"
      sha256 "9ead982edf05b78f0d939098004717225a23c6d0a6047e2bde7916dbfdf7b74a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/takealook97/vat/releases/download/v0.7.0/vat_linux_arm64.tar.gz"
      sha256 "806ac6e26989b4408f26e0d59b2b85f54d0bbbad42cd9bf065d4ab9acfebe995"
    end
    on_intel do
      url "https://github.com/takealook97/vat/releases/download/v0.7.0/vat_linux_amd64.tar.gz"
      sha256 "33440ea9750cee828a7e071481ffdfac9334577def08175bc1eae703d9d01f6c"
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
