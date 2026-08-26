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
      url "https://github.com/takealook97/vat/releases/download/v0.1.5/vat_darwin_arm64.tar.gz"
      sha256 "5dc6787610b1aedb1c72ec03ac6c594505dbdf5bcfcd148ddfe420f92ffeb90e"
    end
    on_intel do
      url "https://github.com/takealook97/vat/releases/download/v0.1.5/vat_darwin_amd64.tar.gz"
      sha256 "e6c8b28cee036143fc4d885939b2ab7ec3c565c8f283ec4cfa3fb2570036486f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/takealook97/vat/releases/download/v0.1.5/vat_linux_arm64.tar.gz"
      sha256 "70fbc360604b0bc58432b62b29742c10e7ce2b50a65adb87ca517873b758bec8"
    end
    on_intel do
      url "https://github.com/takealook97/vat/releases/download/v0.1.5/vat_linux_amd64.tar.gz"
      sha256 "9bb17bd59c7eede8ca4d21c004fc14c5caf6c7c9655f4d61c3efaa3ffea6bb79"
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
