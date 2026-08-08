class Hsin < Formula
  desc "Daemon-first provider switcher for Codex and Claude Code"
  homepage "https://github.com/KyuubiRan/hsin.rs"
  version "0.1.8"
  license "MIT"

  depends_on arch: :arm64 if OS.mac?

  on_macos do
    on_arm do
      url "https://github.com/KyuubiRan/hsin.rs/releases/download/v#{version}/hsin-#{version}-aarch64-apple-darwin.tar.gz"
      sha256 "8218cd93563ce760ded8700cfcb73ffdee61752d9124f45d38c017faa431478b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/KyuubiRan/hsin.rs/releases/download/v#{version}/hsin-#{version}-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "c9b27cedf96161a26767d3d33096877c289cf6f52c1b052aec2771ee0aa0c2c5"
    end
    on_intel do
      url "https://github.com/KyuubiRan/hsin.rs/releases/download/v#{version}/hsin-#{version}-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "b56edbfde36cf016f9542db26b94b793c830c79ab26b4ab231571b8084362e74"
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
