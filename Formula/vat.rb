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
      url "https://github.com/takealook97/vat/releases/download/v0.8.0/vat_darwin_arm64.tar.gz"
      sha256 "f4e95a04c810ed3af0741fd82f7061bf32b21683877bbcb4f27feaa6fafa38ca"
    end
    on_intel do
      url "https://github.com/takealook97/vat/releases/download/v0.8.0/vat_darwin_amd64.tar.gz"
      sha256 "0c7ed9feaad0e5db3a523f8a695970d7518e4f2970bc5d3d16ae7e231f767e17"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/takealook97/vat/releases/download/v0.8.0/vat_linux_arm64.tar.gz"
      sha256 "1e6171d6c1cc2196eccb95575cc484655592ca5411080b9c05ef4126727ef98d"
    end
    on_intel do
      url "https://github.com/takealook97/vat/releases/download/v0.8.0/vat_linux_amd64.tar.gz"
      sha256 "0894279d32d40a100e68bdf73f70ebb68011745f31f2f77cdfa61cfb505203e1"
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
