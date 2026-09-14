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
      url "https://github.com/takealook97/vat/releases/download/v0.6.1/vat_darwin_arm64.tar.gz"
      sha256 "1b34c8a46ba0ae98e6cf51b096066807839b276dd581869f8499003b6b0b4cf9"
    end
    on_intel do
      url "https://github.com/takealook97/vat/releases/download/v0.6.1/vat_darwin_amd64.tar.gz"
      sha256 "c09b5f8166dda112bd005773c4e6b090462eea714c105eec1d1169aae28eb3a6"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/takealook97/vat/releases/download/v0.6.1/vat_linux_arm64.tar.gz"
      sha256 "d74250505196361b3025e3917c52cd2581b0e6bfe1bfacf836c03a4a958a3876"
    end
    on_intel do
      url "https://github.com/takealook97/vat/releases/download/v0.6.1/vat_linux_amd64.tar.gz"
      sha256 "798033309dda3b74cc99550e12a3b3d6720987d59d99866964eb131f82488278"
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
