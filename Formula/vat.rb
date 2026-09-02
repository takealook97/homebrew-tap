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
      url "https://github.com/takealook97/vat/releases/download/v0.5.0/vat_darwin_arm64.tar.gz"
      sha256 "35072026dbd4549905405ff0df5df65330d9a5c5aa56b1b46300bb05934bc478"
    end
    on_intel do
      url "https://github.com/takealook97/vat/releases/download/v0.5.0/vat_darwin_amd64.tar.gz"
      sha256 "855ed214669fb609ae25b4a0ba247c5a2cb1e4eaa0da8718fa4d8ee957194f16"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/takealook97/vat/releases/download/v0.5.0/vat_linux_arm64.tar.gz"
      sha256 "2e4e0930411dc240d25144a66bc4b7a58cfad0126b38bfea4a2b8f07a57b85f4"
    end
    on_intel do
      url "https://github.com/takealook97/vat/releases/download/v0.5.0/vat_linux_amd64.tar.gz"
      sha256 "69b5a94a586ce6a75fb9b69ab5460538cd86abbb3134f6dd1cccd8f7c5d641e6"
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
