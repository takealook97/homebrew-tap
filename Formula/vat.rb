# A control plane for multi-repo workspaces.
#
# Checksums come from the checksums.txt published with each release. Bump the
# version and all four digests together; a partial bump installs one platform
# from a release the others are not from.
class Vat < Formula
  desc "Control plane for multi-repo workspaces, with a knowledge layer that expires"
  homepage "https://github.com/takealook97/vat"
  version "0.1.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/takealook97/vat/releases/download/v0.1.1/vat_darwin_arm64.tar.gz"
      sha256 "fe47361060b573a87e17a51ad73380a9d6da9575c12eb70108d352f86925ae0d"
    end
    on_intel do
      url "https://github.com/takealook97/vat/releases/download/v0.1.1/vat_darwin_amd64.tar.gz"
      sha256 "f4f89afd142e0f6c757dba3eb81deb85a418ced33b508dcb0f5ed7c951d6a7d5"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/takealook97/vat/releases/download/v0.1.1/vat_linux_arm64.tar.gz"
      sha256 "6909a295c0f743f493303394ce210fa80824baa7429119edb19575602be350bc"
    end
    on_intel do
      url "https://github.com/takealook97/vat/releases/download/v0.1.1/vat_linux_amd64.tar.gz"
      sha256 "5a3d1b3dbbe42bdd5ffd25547fde5d9ee26b10b39c0ef6df670af032639467fa"
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
    assert_predicate testpath/"vat.yaml", :exist?
    assert_match "acme", (testpath/"vat.yaml").read
  end
end
