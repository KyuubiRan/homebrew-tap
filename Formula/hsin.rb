class Hsin < Formula
  desc "Daemon-first provider switcher for Codex and Claude Code"
  homepage "https://github.com/KyuubiRan/hsin.rs"
  license "MIT"

  depends_on arch: :arm64 if OS.mac?

  on_macos do
    on_arm do
      url "https://github.com/KyuubiRan/hsin.rs/releases/download/v0.2.2/hsin-aarch64-apple-darwin.tar.gz"
      sha256 "eb580a6782e7bb2d5aee81709973a67c67748a98c39743b5a0d577021b810bae"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/KyuubiRan/hsin.rs/releases/download/v0.2.2/hsin-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "a36aaa9f1877be9e7a5dd7d2337fdef2de3e6d84d31b4c3d360104c678197d3d"
    end
    on_intel do
      url "https://github.com/KyuubiRan/hsin.rs/releases/download/v0.2.2/hsin-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "4307540a37d843579ef8f6c68ff2510390337fea9909905fdfd5b7dcd600288c"
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
