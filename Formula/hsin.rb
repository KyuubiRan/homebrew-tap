class Hsin < Formula
  desc "Daemon-first provider switcher for Codex and Claude Code"
  homepage "https://github.com/KyuubiRan/hsin.rs"
  license "MIT"

  depends_on arch: :arm64 if OS.mac?

  on_macos do
    on_arm do
      url "https://github.com/KyuubiRan/hsin.rs/releases/download/v0.2.6/hsin-aarch64-apple-darwin.tar.gz"
      sha256 "9c85fa946bcbc3d189fe73a500d2fdb415408258eb7931ed091709f3a74b8b59"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/KyuubiRan/hsin.rs/releases/download/v0.2.6/hsin-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "6b20522a87a6843edc50b3252dbcdb12e7fdcf7bcbd177896714dff2b6c96791"
    end
    on_intel do
      url "https://github.com/KyuubiRan/hsin.rs/releases/download/v0.2.6/hsin-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "be1472f8fa8325c52820a818eed1005c2ad96d7def95be99f5788a0aa662e8bd"
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
