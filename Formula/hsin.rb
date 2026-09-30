class Hsin < Formula
  desc "Daemon-first provider switcher for Codex and Claude Code"
  homepage "https://github.com/KyuubiRan/hsin.rs"
  license "MIT"

  depends_on arch: :arm64 if OS.mac?

  on_macos do
    on_arm do
      url "https://github.com/KyuubiRan/hsin.rs/releases/download/v0.2.8/hsin-aarch64-apple-darwin.tar.gz"
      sha256 "0525fe80670db47abccd7f8ad3f0b03f7a766f8bb794e2f3f5fb787c28171134"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/KyuubiRan/hsin.rs/releases/download/v0.2.8/hsin-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "833aa7b6036f3913f5e2f8a3da26306991da389f863924c8f7e72db368e92ad2"
    end
    on_intel do
      url "https://github.com/KyuubiRan/hsin.rs/releases/download/v0.2.8/hsin-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "aff01c62e463082ec6eac502e9ebf2abaea71ebd8b54fd4fe29f71556560d7aa"
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
