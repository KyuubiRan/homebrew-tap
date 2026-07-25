#!/bin/sh
# Update Formula/hsin.rb to a published hsin.rs release.
#
# Usage: scripts/update-formula.sh v0.1.0
#
# Reads the SHA256SUMS asset attached to the release and rewrites the version
# and every sha256 line in the formula.
set -eu

tag="${1:?usage: scripts/update-formula.sh <tag>}"
version="${tag#v}"
repo="KyuubiRan/hsin.rs"
formula="$(dirname "$0")/../Formula/hsin.rb"

sums="$(mktemp)"
trap 'rm -f "$sums"' EXIT
gh release download "$tag" --repo "$repo" --pattern SHA256SUMS --output "$sums" --clobber

digest_for() {
  awk -v want="hsin-${version}-$1.tar.gz" '$2 == want { print $1 }' "$sums"
}

sed -i.bak "s/^  version \".*\"$/  version \"${version}\"/" "$formula"

for target in \
  aarch64-apple-darwin \
  x86_64-apple-darwin \
  aarch64-unknown-linux-gnu \
  x86_64-unknown-linux-gnu
do
  digest="$(digest_for "$target")"
  if [ -z "$digest" ]; then
    echo "no checksum for $target in $tag SHA256SUMS" >&2
    exit 1
  fi
  # Replace the sha256 on the line following this target's url line.
  awk -v target="$target" -v digest="$digest" '
    index($0, target ".tar.gz") { print; getline; sub(/"[^"]*"/, "\"" digest "\""); print; next }
    { print }
  ' "$formula" >"${formula}.tmp"
  mv "${formula}.tmp" "$formula"
done

rm -f "${formula}.bak"
echo "updated $formula to ${version}"
grep -E '^  version|sha256' "$formula"
