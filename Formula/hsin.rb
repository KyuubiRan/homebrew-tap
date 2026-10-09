class Hsin < Formula
  desc "Daemon-first provider switcher for Codex and Claude Code"
  homepage "https://github.com/KyuubiRan/hsin.rs"
  license "MIT"

  depends_on arch: :arm64 if OS.mac?

  on_macos do
    on_arm do
      url "https://github.com/KyuubiRan/hsin.rs/releases/download/v0.3.1/hsin-aarch64-apple-darwin.tar.gz"
      sha256 "94ade8c52d84dbec767817fa86d903c24a365dc92374c69b521c91bdae42b1c0"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/KyuubiRan/hsin.rs/releases/download/v0.3.1/hsin-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "b69c0e2561415c7625b7910db6778ea8e462dfed6f452b574a259a585f073542"
    end
    on_intel do
      url "https://github.com/KyuubiRan/hsin.rs/releases/download/v0.3.1/hsin-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "2aac63152bc287482f284ba981001f56ce6ecc04f9feb6135dfe04948fab2bf9"
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
