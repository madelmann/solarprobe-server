#!/bin/bash

CLIENT_DIRECTORY=$(dirname "$0")
EXTENSION_DIRECTORY="${CLIENT_DIRECTORY}/extensions"

source "${CLIENT_DIRECTORY}/client.conf"

PROBES_CONF="${CLIENT_DIRECTORY}/probes.conf"

while read -r probe; do

  if [ -n "${EXTENSION_DIRECTORY}/${probe}" ]; then

    echo "Probing $probe..."

    ${CLIENT_DIRECTORY}/xymon/post.sh "${SERVER}/solarprobe/api/xymon/report.sh" "$(hostname)" "${EXTENSION_DIRECTORY}/${probe}"

  fi

done < "$PROBES_CONF"

