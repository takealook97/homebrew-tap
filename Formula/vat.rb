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
      sha256 "8c45e346fe4f68f3cc9562b5640964f3b6a53819b6434f7dc4d77d331446fb71"
    end
    on_intel do
      url "https://github.com/takealook97/vat/releases/download/v0.1.0/vat_darwin_amd64.tar.gz"
      sha256 "ee1c84b33c2388df6034b8c83ea42f6b00b4674b1b2b2eaaa5dbae10a4b23201"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/takealook97/vat/releases/download/v0.1.0/vat_linux_arm64.tar.gz"
      sha256 "02ca180106182943659655de59609027e102964eda26442cb5dbfaf522a67918"
    end
    on_intel do
      url "https://github.com/takealook97/vat/releases/download/v0.1.0/vat_linux_amd64.tar.gz"
      sha256 "8237ccc66c6415b61999507cc136b8d57a755cd997d8e51c76deee14dae08c24"
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
