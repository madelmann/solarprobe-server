#!/bin/bash

BASE_DIRECTORY=$(dirname "$0")

source "${BASE_DIRECTORY}/config/base.conf"

TTL=300
now=$(date +%s)

[ $# -eq 1 ] || { echo "Usage: $0 <node>"; exit 1; }
NODE="$1"

NODE_DIR="${BASE_DIRECTORY}/$NODE"
OUT="${WWW}/$NODE.html"

mkdir -p "${WWW}"

cat > "$OUT" <<EOF
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="refresh" content="30">
<title>$NODE: $PROBE</title>
<style>
body { font-family:sans-serif; background:#111; color:#eee; }
table { border-collapse: collapse; }
th, td { padding: 6px 10px; text-align: center; }
th { background:#222; }
td.probe { font-weight:bold; }
.green { background:#2ecc71; color:#000; }
.yellow { background:#f1c40f; color:#000; }
.red { background:#e74c3c; color:#000; }
.blue { background:#3498db; color:#000; }
.small { font-size: 0.8em; }
</style>
</head>
<body>
<h1>$NODE: $PROBE</h1>
<p class="small">Updated: $(date)</p>
<table border="1">
<tr><th>Probe</th><th>State</th><th>Summary</th><th>History</th></tr>
EOF

for probefile in "$NODE_DIR"/*.status; do
  [ -f "$probefile" ] || continue
  probe=$(basename "$probefile" .status)

  # load current state
  . "$probefile"
  [ $((now - timestamp)) -gt "$TTL" ] && state=blue

  # generate history string
  HISTFILE="$NODE_DIR/history/$probe.log"
  history=""
  if [ -f "$HISTFILE" ]; then
    history=$(tail -n 10 "$HISTFILE" | awk -F'|' '{printf "%s(%s) ", $2, strftime("%H:%M:%S",$1)}')
  fi

  echo "<tr>" >> "$OUT"
  echo "<td class=\"probe\">$probe</td>" >> "$OUT"
  echo "<td class=\"$state\">$state</td>" >> "$OUT"
  echo "<td>$summary</td>" >> "$OUT"
  echo "<td class=\"small\">$history</td>" >> "$OUT"
  echo "</tr>" >> "$OUT"
done

echo "</table></body></html>" >> "$OUT"
