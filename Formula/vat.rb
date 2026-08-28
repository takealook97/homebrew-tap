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
      url "https://github.com/takealook97/vat/releases/download/v0.4.0/vat_darwin_arm64.tar.gz"
      sha256 "60ce5fedecc3ec9706cf705f4c6f8d6e3745113fb1727aa9fc579f49a724dae5"
    end
    on_intel do
      url "https://github.com/takealook97/vat/releases/download/v0.4.0/vat_darwin_amd64.tar.gz"
      sha256 "f5cd311f2343ba8388d5132402331ea3d194b1384d3d283e32741c6e75e4a5d1"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/takealook97/vat/releases/download/v0.4.0/vat_linux_arm64.tar.gz"
      sha256 "15b2b093d8e42bd969025cdf137132160b4fa22dfe798ca77e3942df37e4acc6"
    end
    on_intel do
      url "https://github.com/takealook97/vat/releases/download/v0.4.0/vat_linux_amd64.tar.gz"
      sha256 "bb94d911177eafaecb250511e21a9f9fc1baeef92ff96dbda7c5532fafb06e5f"
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
