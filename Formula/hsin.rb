class Hsin < Formula
  desc "Daemon-first provider switcher for Codex and Claude Code"
  homepage "https://github.com/KyuubiRan/hsin.rs"
  version "0.2.0"
  license "MIT"

  depends_on arch: :arm64 if OS.mac?

  on_macos do
    on_arm do
      url "https://github.com/KyuubiRan/hsin.rs/releases/download/v#{version}/hsin-aarch64-apple-darwin.tar.gz"
      sha256 "501e0f3db808c9b9d35140bb650ec2c2c3ac79d195c8ce177a6af0fd9aa20dc2"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/KyuubiRan/hsin.rs/releases/download/v#{version}/hsin-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "94f85dff35b3e16275290ddab7d7c684081035c2e14f108b4fb54df2860748ba"
    end
    on_intel do
      url "https://github.com/KyuubiRan/hsin.rs/releases/download/v#{version}/hsin-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "2eac6d2554ae7c2dbec7b16429dc77a43eaf27437fb278f45d077c9420558046"
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
