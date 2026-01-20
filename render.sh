#!/bin/sh
#set -eu

. "config/base.conf"

TTL=300   # seconds before a probe turns blue

now=$(date +%s)

# --- helpers ----------------------------------------------------

color_class() {
  case "$1" in
    green)  echo "green" ;;
    yellow) echo "yellow" ;;
    red)    echo "red" ;;
    blue|*) echo "blue" ;;
  esac
}

load_state() {
  file="$1"
  if [ ! -f "$file" ]; then
    echo "blue|no data"
    return
  fi

  # shellcheck disable=SC1090
  . "$file"

  if [ $((now - timestamp)) -gt "$TTL" ]; then
    echo "blue|stale"
  else
    echo "$state|$summary"
  fi
}

# --- HTML header ------------------------------------------------

cat > "$OUT" <<EOF
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="refresh" content="30">
<title>Probe Status</title>
<style>
body { font-family: sans-serif; background:#111; color:#eee; }
table { border-collapse: collapse; }
th, td { padding: 6px 10px; text-align: center; }
th { background:#222; }
td.node { text-align: left; font-weight: bold; }
.green  { background:#2ecc71; color:#000; }
.yellow { background:#f1c40f; color:#000; }
.red    { background:#e74c3c; color:#000; }
.blue   { background:#3498db; color:#000; }
.small  { font-size: 0.8em; }
</style>
</head>
<body>
<h1>Probe Status</h1>
<p class="small">Updated: $(date)</p>
<table border="1">
<tr>
<th>Node</th>
EOF

# --- column headers --------------------------------------------

while read -r probe; do
  [ -n "$probe" ] && echo "<th>$probe</th>" >> "$OUT"
done < "$PROBES_CONF"

echo "</tr>" >> "$OUT"

# --- rows -------------------------------------------------------

for nodepath in "$NODES"/*; do
  [ -d "$nodepath" ] || continue
  node=$(basename "$nodepath")

  echo "<tr><td class=\"node\">$node</td>" >> "$OUT"

  while read -r probe; do
    [ -n "$probe" ] || continue

    statusfile="$nodepath/$probe.status"
    result=$(load_state "$statusfile")

    state=${result%%|*}
    #echo "state '$state'";
    summary=${result#*|}
    #echo "summary '$summary'";

    class=$(color_class "$state")

    echo "<td class=\"$class\" title=\"$summary\">$state</td>" >> "$OUT"
  done < "$PROBES_CONF"

  echo "</tr>" >> "$OUT"
done

# --- footer ----------------------------------------------------

cat >> "$OUT" <<EOF
</table>
</body>
</html>
EOF

