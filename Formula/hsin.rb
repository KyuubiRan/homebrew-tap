class Hsin < Formula
  desc "Daemon-first provider switcher for Codex and Claude Code"
  homepage "https://github.com/KyuubiRan/hsin.rs"
  license "MIT"

  depends_on arch: :arm64 if OS.mac?

  on_macos do
    on_arm do
      url "https://github.com/KyuubiRan/hsin.rs/releases/download/v0.2.5/hsin-aarch64-apple-darwin.tar.gz"
      sha256 "cedd673caed0874ac5f4e2eb70ccdf7ed01506786aa804198af58c8e206d8bcd"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/KyuubiRan/hsin.rs/releases/download/v0.2.5/hsin-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "63afc65ffa364b16a6cbaa8c8aa605abf85811aa20ae685d520d4b1a133082c3"
    end
    on_intel do
      url "https://github.com/KyuubiRan/hsin.rs/releases/download/v0.2.5/hsin-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "49bec56d73480020d93b3f716f8ee93b56a5296c318621214ff41b68e86778a4"
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
