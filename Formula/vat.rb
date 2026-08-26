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
      url "https://github.com/takealook97/vat/releases/download/v0.1.4/vat_darwin_arm64.tar.gz"
      sha256 "ed7ade86468a59f5920ebe2ae94dc145e658890ef7aa4a8dbdb8e585b0ea70b5"
    end
    on_intel do
      url "https://github.com/takealook97/vat/releases/download/v0.1.4/vat_darwin_amd64.tar.gz"
      sha256 "65e92f3fdaab463b760394bcc40a8b0b21e0396c9b495002915be80cdfa7bc96"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/takealook97/vat/releases/download/v0.1.4/vat_linux_arm64.tar.gz"
      sha256 "3a8fa630d15b60649e4e23787e42b02c14a60c283462eb3cfb877d567a434e3f"
    end
    on_intel do
      url "https://github.com/takealook97/vat/releases/download/v0.1.4/vat_linux_amd64.tar.gz"
      sha256 "831f4daa08b11f3badb0e920add13909afa1c36ab584e0837a85b9b4b92f78cb"
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
