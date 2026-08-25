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
      sha256 "f43cad5d4789a4e4ba3911d4f1725d8162735b6e4c75201edee28f1f410b8ac0"
    end
    on_intel do
      url "https://github.com/takealook97/vat/releases/download/v0.1.0/vat_darwin_amd64.tar.gz"
      sha256 "9bf9db33e08eea8d34ec1484b724da059f9a5308ae963445aee1d34bee729328"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/takealook97/vat/releases/download/v0.1.0/vat_linux_arm64.tar.gz"
      sha256 "130f59ef3bc2e5b34bf7eb4d74df6699555259d1e1e7fb534ce9d2909b3460e5"
    end
    on_intel do
      url "https://github.com/takealook97/vat/releases/download/v0.1.0/vat_linux_amd64.tar.gz"
      sha256 "71fdc48de4815b95fcceb5a1b8cf57ec391f5b09d746d92601d8ac4169a800fd"
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
