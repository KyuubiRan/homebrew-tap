class Hsin < Formula
  desc "Daemon-first provider switcher for Codex and Claude Code"
  homepage "https://github.com/KyuubiRan/hsin.rs"
  license "MIT"

  depends_on arch: :arm64 if OS.mac?

  on_macos do
    on_arm do
      url "https://github.com/KyuubiRan/hsin.rs/releases/download/v0.3.0/hsin-aarch64-apple-darwin.tar.gz"
      sha256 "6759db1bdd3061ca132c8e39db7e94e17285c74513d7fde2f442377a5d4d77b7"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/KyuubiRan/hsin.rs/releases/download/v0.3.0/hsin-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "dba7c9b9f1c8d418eb46ae307616c59092300c348b8095e40f02ce46de475f49"
    end
    on_intel do
      url "https://github.com/KyuubiRan/hsin.rs/releases/download/v0.3.0/hsin-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "0da13bc40b99b738c63e5e9c35b7341f85e4af24be647741c002c66a78cc4125"
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
