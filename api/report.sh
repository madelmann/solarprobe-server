#!/bin/sh
set -eu

. "config/base.conf"

# Read JSON body (very naive, prototype only)
body="$(cat)"

node=$(echo "$body" | sed -n 's/.*"node"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p')
probe=$(echo "$body" | sed -n 's/.*"probe"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p')
state=$(echo "$body" | sed -n 's/.*"state"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p')
summary=$(echo "$body" | sed -n 's/.*"summary"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p')

[ -n "$node" ] || exit 1
[ -n "$probe" ] || exit 1

dir="$NODES/$node"
file="$dir/$probe.status"
tmp="$file.$$"

mkdir -p "$dir"

{
  echo "state=$state"
  echo "timestamp=$(date +%s)"
  echo "summary=\"$summary\""
} > "$tmp"

mv "$tmp" "$file"

echo "Status: 204 No Content"
echo
