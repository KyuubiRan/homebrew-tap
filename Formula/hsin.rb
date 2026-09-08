class Hsin < Formula
  desc "Daemon-first provider switcher for Codex and Claude Code"
  homepage "https://github.com/KyuubiRan/hsin.rs"
  license "MIT"

  depends_on arch: :arm64 if OS.mac?

  on_macos do
    on_arm do
      url "https://github.com/KyuubiRan/hsin.rs/releases/download/v0.2.4/hsin-aarch64-apple-darwin.tar.gz"
      sha256 "9fd86591f1e6cd741282ac1de2a1d9209165be6564f1052c6dd846e675725bd4"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/KyuubiRan/hsin.rs/releases/download/v0.2.4/hsin-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "9b22535a68edbc2702e5818d870232451969e6ea30aa29cc5d66e55c7a379efb"
    end
    on_intel do
      url "https://github.com/KyuubiRan/hsin.rs/releases/download/v0.2.4/hsin-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "080fc197d271056d3aa73d7c50fae6e3a59400da2f304516c4387e03f75ff31a"
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
