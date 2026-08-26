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
      url "https://github.com/takealook97/vat/releases/download/v0.1.3/vat_darwin_arm64.tar.gz"
      sha256 "ce65d3af63affae532df2ded8e25c6e2d960de47c88b75c67f9557f6f2ba7cdc"
    end
    on_intel do
      url "https://github.com/takealook97/vat/releases/download/v0.1.3/vat_darwin_amd64.tar.gz"
      sha256 "e812ab9a9d4790abebcd0dab6a749f1be82d89feccd296429d3f9684e4114547"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/takealook97/vat/releases/download/v0.1.3/vat_linux_arm64.tar.gz"
      sha256 "6ba8c2a49172e5772f284052d338c289189e5892f3e9a845cf5dda46ee0b14ab"
    end
    on_intel do
      url "https://github.com/takealook97/vat/releases/download/v0.1.3/vat_linux_amd64.tar.gz"
      sha256 "0a3dad3e2f926c7f64d625ed26812cef1f1b58562adc25e138e7d8f9775ebb1b"
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
