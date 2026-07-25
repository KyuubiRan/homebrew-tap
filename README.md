# homebrew-tap

Homebrew tap for [hsin](https://github.com/KyuubiRan/hsin.rs).

## Install

```bash
brew install KyuubiRan/tap/hsin
```

Then set up the background daemon:

```bash
hsind service install --start
hsin
```

## Updating the formula for a new release

After publishing a release in `KyuubiRan/hsin.rs`:

```bash
scripts/update-formula.sh v0.1.0
git commit -am "hsin 0.1.0"
git push
```

The script pulls the release's `SHA256SUMS` asset and rewrites the version and
all four platform checksums in `Formula/hsin.rb`.

## Notes

The daemon registers its own launchd/systemd service through
`hsind service install`, so the formula deliberately does not define a Homebrew
`service` block — two definitions would compete for the same IPC endpoint.
