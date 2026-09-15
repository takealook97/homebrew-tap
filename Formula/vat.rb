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
      url "https://github.com/takealook97/vat/releases/download/v0.6.2/vat_darwin_arm64.tar.gz"
      sha256 "c3331ee6718fe0b451c881ac511e00e79bbe480f827cabfa8587bf7bc1955832"
    end
    on_intel do
      url "https://github.com/takealook97/vat/releases/download/v0.6.2/vat_darwin_amd64.tar.gz"
      sha256 "29ca1656bc921d6ce61957e7932da168ae2f4e097939d0c61e0803119e7d18ed"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/takealook97/vat/releases/download/v0.6.2/vat_linux_arm64.tar.gz"
      sha256 "ff15a9768ded0727a3fdb2a9de6a8ec833179be435aa901371b69b8008639330"
    end
    on_intel do
      url "https://github.com/takealook97/vat/releases/download/v0.6.2/vat_linux_amd64.tar.gz"
      sha256 "64a3e78d36a91597773a6a8b4495c9f603f3e927c81ac5a2331b783b3dc2f82b"
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
