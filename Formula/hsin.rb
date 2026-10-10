class Hsin < Formula
  desc "Daemon-first provider switcher for Codex and Claude Code"
  homepage "https://github.com/KyuubiRan/hsin.rs"
  license "MIT"

  depends_on arch: :arm64 if OS.mac?

  on_macos do
    on_arm do
      url "https://github.com/KyuubiRan/hsin.rs/releases/download/v0.3.2/hsin-aarch64-apple-darwin.tar.gz"
      sha256 "3f39b67da1a2c99d0f202494a23d88a758a2febbde332996c0e4df51cee14ab7"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/KyuubiRan/hsin.rs/releases/download/v0.3.2/hsin-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "d134b6fc0c97b7678d81ecebe3dd1db6a52d7169a5c2b454a449ccf8f2f9aaa1"
    end
    on_intel do
      url "https://github.com/KyuubiRan/hsin.rs/releases/download/v0.3.2/hsin-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "cd01195a62c5ec80cfdcd850dd442fe536b850573e54fcddd28e7e9457b2ecba"
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
