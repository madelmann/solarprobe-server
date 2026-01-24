#!/bin/sh
# Wrapper to send Xymon extension output to probe server
# Usage: xymon-post.sh <hostname> <probe-server-url> [extension ... args]

#set -eu

if [ $# -lt 2 ]; then
  echo "Usage: $0 <hostname> <server-url> [extension ...]" >&2
  exit 1
fi

SERVER="$1"
CLIENT="$2"
shift 2

# Run the Xymon extension, capture output
EXT_OUTPUT="$("$@" 2>&1)" || true

# Prepare payload: prepend hostname if needed
PAYLOAD=$(echo "$EXT_OUTPUT" | while IFS= read -r line; do
  [ -n "$line" ] || continue
  # If line already has hostname, leave as-is; else prepend CLIENT.
  case "$line" in
    "$CLIENT".*) echo "$line" ;;
    *) echo "$CLIENT.$line" ;;
  esac
done)

# Send to probe server
curl -s -X POST "$SERVER" \
     -H "Content-Type: text/plain" \
     --data-binary "$PAYLOAD"

# Exit code of the extension (optional: propagate)
exit 0
