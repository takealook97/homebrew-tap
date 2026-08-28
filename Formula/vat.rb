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
      url "https://github.com/takealook97/vat/releases/download/v0.2.0/vat_darwin_arm64.tar.gz"
      sha256 "8cd98b87e80f0bc42e08f3a80f8cb45bdbe9ab928a9f782dd67f123371c1fc98"
    end
    on_intel do
      url "https://github.com/takealook97/vat/releases/download/v0.2.0/vat_darwin_amd64.tar.gz"
      sha256 "ba514fb73af318b0722b565e0d34504d4eb0c591699586fafc93717f2eb69060"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/takealook97/vat/releases/download/v0.2.0/vat_linux_arm64.tar.gz"
      sha256 "3534bc01fd8365b14db53680e74af9047f641dc18030fb64f1dce6b63fa61165"
    end
    on_intel do
      url "https://github.com/takealook97/vat/releases/download/v0.2.0/vat_linux_amd64.tar.gz"
      sha256 "a7ba199f2058ca440834c95142b877a1454b240e7038e89ca7dff0908785c08d"
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
