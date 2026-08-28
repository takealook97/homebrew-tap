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
      url "https://github.com/takealook97/vat/releases/download/v0.4.2/vat_darwin_arm64.tar.gz"
      sha256 "5141af00919401b55edf24dd68c87a5de8e8909649182004b18fff22b255007b"
    end
    on_intel do
      url "https://github.com/takealook97/vat/releases/download/v0.4.2/vat_darwin_amd64.tar.gz"
      sha256 "1246c523d07df5a39ee69fdfd4ae6ac4034ed0a826eae9b61cdf3d0da678d0fc"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/takealook97/vat/releases/download/v0.4.2/vat_linux_arm64.tar.gz"
      sha256 "4d4ba766830e8bcc59b760a9b7e34b7413a11102a95f0612af78b9ca00109f5b"
    end
    on_intel do
      url "https://github.com/takealook97/vat/releases/download/v0.4.2/vat_linux_amd64.tar.gz"
      sha256 "b63382243c21c80afaa0bae0bbcfbf060c7fe31459e2ef31808e1b6eaac256bc"
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
