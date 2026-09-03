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
      url "https://github.com/takealook97/vat/releases/download/v0.5.2/vat_darwin_arm64.tar.gz"
      sha256 "efb6935c0690066155580794ec1fff17a2b4b93122e8d0f7131c590bd0cd59b7"
    end
    on_intel do
      url "https://github.com/takealook97/vat/releases/download/v0.5.2/vat_darwin_amd64.tar.gz"
      sha256 "38fbd7b0b85e6bab714ae8f14a33f05efdd18b511a78ba67ee1c66ee4b1109f2"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/takealook97/vat/releases/download/v0.5.2/vat_linux_arm64.tar.gz"
      sha256 "d6f4e82c759f5584a4afa7bbd7998a107a1f5bf30301bbfb53d9cf4273064514"
    end
    on_intel do
      url "https://github.com/takealook97/vat/releases/download/v0.5.2/vat_linux_amd64.tar.gz"
      sha256 "a51ab19aa2de8dccccf66e6574963f76bf125f820c436532459dafe7394597a8"
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
