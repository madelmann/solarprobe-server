#!/bin/sh
#set -eu

. "config/base.conf"

TMPDIR="/tmp"

# read entire request body
BODY="$(cat)"

now=$(date +%s)

# iterate over each line
echo "$BODY" | while read -r line; do
  # skip empty lines
  [ -n "$line" ] || continue

  # parse Xymon client format: node.service color message
  node_service=$(echo "$line" | awk '{print $1}')
  state=$(echo "$line" | awk '{print $2}')
  summary=$(echo "$line" | cut -d' ' -f3-)

  # split node and probe
  node=${node_service%%.*}
  probe=${node_service#*.}

  [ -n "$node" ] || continue
  [ -n "$probe" ] || continue

  dir="$NODES/$node"
  mkdir -p "$dir/history/"

  echo "$(date) $BODY" >> "$NODES/$node/incoming.log"

  file="$dir/$probe.status"
  tmp="$TMPDIR/$probe.status.$$"

  {
    echo "state=$state"
    echo "timestamp=$now"
    echo "summary=\"$summary\""
  } > "$tmp"

  # atomic rename
  mv "$tmp" "$file"
done

# Return HTTP response
echo "Status: 204 No Content"
echo
