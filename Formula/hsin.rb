class Hsin < Formula
  desc "Daemon-first provider switcher for Codex and Claude Code"
  homepage "https://github.com/KyuubiRan/hsin.rs"
  version "0.1.3"
  license "MIT"

  depends_on arch: :arm64 if OS.mac?

  on_macos do
    on_arm do
      url "https://github.com/KyuubiRan/hsin.rs/releases/download/v#{version}/hsin-#{version}-aarch64-apple-darwin.tar.gz"
      sha256 "3fd1da2e52ab35f5df03ee330d3e9e196a5aa4dd80807c7a263cdab055a2a9b3"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/KyuubiRan/hsin.rs/releases/download/v#{version}/hsin-#{version}-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "ca9939f62dda6bd1566ecd763a70240c2e61b8371f0080569e6745132f63ec10"
    end
    on_intel do
      url "https://github.com/KyuubiRan/hsin.rs/releases/download/v#{version}/hsin-#{version}-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "386a0f2c0571cf41ff6f9f351f6bf5c31940524b765f2519f4e1cddefba19ae5"
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
