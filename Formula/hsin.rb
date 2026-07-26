class Hsin < Formula
  desc "Daemon-first provider switcher for Codex and Claude Code"
  homepage "https://github.com/KyuubiRan/hsin.rs"
  version "0.1.0"
  license "MIT"

  depends_on arch: :arm64 if OS.mac?

  on_macos do
    on_arm do
      url "https://github.com/KyuubiRan/hsin.rs/releases/download/v#{version}/hsin-#{version}-aarch64-apple-darwin.tar.gz"
      sha256 "dfce16c933e23c89d52d1b84a24c4f3caf1252d95e3d4d44d3f0c079a1d052f1"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/KyuubiRan/hsin.rs/releases/download/v#{version}/hsin-#{version}-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "3c2d337f5ccbbd3bae95a4a57cdec9f73d66120ff092b183b609d2934e9fd12d"
    end
    on_intel do
      url "https://github.com/KyuubiRan/hsin.rs/releases/download/v#{version}/hsin-#{version}-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "cbdcbcc165d42b11e4e78189acad1629cd23053caa12f852eb67ff99ef85766c"
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
