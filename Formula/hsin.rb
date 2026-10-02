class Hsin < Formula
  desc "Daemon-first provider switcher for Codex and Claude Code"
  homepage "https://github.com/KyuubiRan/hsin.rs"
  license "MIT"

  depends_on arch: :arm64 if OS.mac?

  on_macos do
    on_arm do
      url "https://github.com/KyuubiRan/hsin.rs/releases/download/v0.2.9/hsin-aarch64-apple-darwin.tar.gz"
      sha256 "18e4bd18e0d34748a85fdf30a14158c3f8ec08204bef8ed1f978488e0da5bcec"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/KyuubiRan/hsin.rs/releases/download/v0.2.9/hsin-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "6b6f6d5adff7eea2ea90f1e10ed2608d5fee41a74574577ca74fd4f90b2a4878"
    end
    on_intel do
      url "https://github.com/KyuubiRan/hsin.rs/releases/download/v0.2.9/hsin-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "80a5cb542ac5fbea649f46d31ff03cbb2f7b69255f135f65a58b495904a4ea15"
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
