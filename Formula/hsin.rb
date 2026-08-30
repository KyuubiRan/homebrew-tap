class Hsin < Formula
  desc "Daemon-first provider switcher for Codex and Claude Code"
  homepage "https://github.com/KyuubiRan/hsin.rs"
  license "MIT"

  depends_on arch: :arm64 if OS.mac?

  on_macos do
    on_arm do
      url "https://github.com/KyuubiRan/hsin.rs/releases/download/v0.2.3/hsin-aarch64-apple-darwin.tar.gz"
      sha256 "0a59524786b0c9c5d6f3e12a55119671bb23b78e60a5052f83f08e0364a1a621"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/KyuubiRan/hsin.rs/releases/download/v0.2.3/hsin-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "8e8c4f0c88bfd6d5b03039091cae2918682c7cdaf9f88c55f12531daf24d038f"
    end
    on_intel do
      url "https://github.com/KyuubiRan/hsin.rs/releases/download/v0.2.3/hsin-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "fd8201bd6bdf7a41e14d38f87b7f2d82e100530b3897a9796626a58c67133be6"
    end
  end

  def install
    bin.install "hsin", "hsind"
  end

  # The daemon manages its own launchd/systemd definition through
  # `hsin daemon install`, which copies the binaries into the hsin home and
  # registers them there. A Homebrew service block would register a second
  # definition competing for the same IPC endpoint, so it is omitted on purpose.
  def caveats
    <<~EOS
      Install and start the background daemon:
        hsin daemon install --start

      Then open the terminal UI:
        hsin

      Remove the daemon before uninstalling this formula:
        hsin daemon uninstall
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hsin --version")
    assert_match version.to_s, shell_output("#{bin}/hsind --version")
  end
end
