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
      sha256 "534594cf3d1c4588e6a44e0a24852df37b7325baee57a349a3823a45cef76eac"
    end
    on_intel do
      url "https://github.com/takealook97/vat/releases/download/v0.1.0/vat_darwin_amd64.tar.gz"
      sha256 "9ed4210df39599628696143de71b8bdda50332ed432cd1cfd7623322a4c8aac7"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/takealook97/vat/releases/download/v0.1.0/vat_linux_arm64.tar.gz"
      sha256 "8f31c8b76cc4257e07fc82a7a53de078188c4c39b95b21b74828bbe4e0a1ac68"
    end
    on_intel do
      url "https://github.com/takealook97/vat/releases/download/v0.1.0/vat_linux_amd64.tar.gz"
      sha256 "5d6122093eaa19190fad5fb6b133587fd99894997e318f9fb220d03627a4ab37"
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
