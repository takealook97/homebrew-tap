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
      url "https://github.com/takealook97/vat/releases/download/v0.1.2/vat_darwin_arm64.tar.gz"
      sha256 "80c1fba52fdb13dfe8278024a446dc974ec80750571353b830ec2207033f1854"
    end
    on_intel do
      url "https://github.com/takealook97/vat/releases/download/v0.1.2/vat_darwin_amd64.tar.gz"
      sha256 "74c9f65b80cf03c002ed5f7e921caf46c9115216fa54aaf54ca4fd58ed56cab9"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/takealook97/vat/releases/download/v0.1.2/vat_linux_arm64.tar.gz"
      sha256 "f04e2c303eb1ad5dd4110f29fc175001ffc33486df4878eae761febc49aa58af"
    end
    on_intel do
      url "https://github.com/takealook97/vat/releases/download/v0.1.2/vat_linux_amd64.tar.gz"
      sha256 "99c507267afa9a85d74155b5081b65129ae6d90f0814dea9b55590b432e501bf"
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
