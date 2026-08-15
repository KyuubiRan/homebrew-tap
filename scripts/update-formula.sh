#!/bin/sh
# Update a formula in this tap to a published GitHub release.
#
# Usage: scripts/update-formula.sh <formula> <tag>
#   e.g. scripts/update-formula.sh hsin v0.1.0
#
# The upstream repo is read from the formula's `homepage`. Every `url` line is
# resolved against the release's SHA256SUMS asset and the sha256 line below it
# is rewritten, along with either an explicit version or the tag in release URLs.
set -eu

name="${1:?usage: scripts/update-formula.sh <formula> <tag>}"
tag="${2:?usage: scripts/update-formula.sh <formula> <tag>}"
version="${tag#v}"
formula="$(dirname "$0")/../Formula/${name}.rb"

if [ ! -f "$formula" ]; then
  echo "no such formula: $formula" >&2
  exit 1
fi

repo="$(sed -n 's|^ *homepage "https://github.com/\([^/"]*/[^/"]*\)".*|\1|p' "$formula")"
if [ -z "$repo" ]; then
  echo "could not read a github repo from the homepage in $formula" >&2
  exit 1
fi

sums="$(mktemp)"
trap 'rm -f "$sums"' EXIT
gh release download "$tag" --repo "$repo" --pattern SHA256SUMS --output "$sums" --clobber

if grep -q '^  version ".*"$' "$formula"; then
  sed -i.bak "s/^  version \".*\"$/  version \"${version}\"/" "$formula"
fi
sed -i.bak -E "s|(releases/download/)v[^/]+/|\\1${tag}/|g" "$formula"
rm -f "${formula}.bak"

# Pair each url line with the digest of the asset it points at, then replace the
# sha256 on the line that follows it.
if awk -v version="$version" '
  NR == FNR { digest[$2] = $1; next }
  /^ *url "/ {
    print
    asset = $0
    sub(/^.*\//, "", asset)
    sub(/".*$/, "", asset)
    gsub(/#\{version\}/, version, asset)
    if (!(asset in digest)) {
      print "no checksum for " asset " in SHA256SUMS" > "/dev/stderr"
      exit 1
    }
    getline
    sub(/"[^"]*"/, "\"" digest[asset] "\"")
    print
    next
  }
  { print }
' "$sums" "$formula" >"${formula}.tmp"; then
  mv "${formula}.tmp" "$formula"
else
  rm -f "${formula}.tmp"
  exit 1
fi

echo "updated $formula to ${version}"
grep -E '^  version|releases/download|sha256' "$formula"
