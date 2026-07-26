class Hsin < Formula
  desc "Daemon-first provider switcher for Codex and Claude Code"
  homepage "https://github.com/KyuubiRan/hsin.rs"
  version "0.1.2"
  license "MIT"

  depends_on arch: :arm64 if OS.mac?

  on_macos do
    on_arm do
      url "https://github.com/KyuubiRan/hsin.rs/releases/download/v#{version}/hsin-#{version}-aarch64-apple-darwin.tar.gz"
      sha256 "f211f53b1e0a3e7d530a9f97221b4480879ccbc5d07092f64f7d79c67d81ee69"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/KyuubiRan/hsin.rs/releases/download/v#{version}/hsin-#{version}-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "47862bd7e8701f1465db7718b6aa96724af8fd6e38285e7197617a3b6babdb6a"
    end
    on_intel do
      url "https://github.com/KyuubiRan/hsin.rs/releases/download/v#{version}/hsin-#{version}-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "e99f6c99b1b4690faf3a644ec53639e01117232b2ac9edc6e6e5ba532f7b3d13"
    end
  end

  def install
    bin.install "hsin", "hsind"
  end

  # The daemon manages its own launchd/systemd definition through
  # `hsind service install`, which copies the binaries into the hsin home and
  # registers them there. A Homebrew service block would register a second
  # definition competing for the same IPC endpoint, so it is omitted on purpose.
  def caveats
    <<~EOS
      Install and start the background daemon:
        hsind service install --start

      Then open the terminal UI:
        hsin

      Remove the daemon before uninstalling this formula:
        hsind service uninstall
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hsin --version")
    assert_match version.to_s, shell_output("#{bin}/hsind --version")
  end
end
