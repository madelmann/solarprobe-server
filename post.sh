#!/bin/sh

api/xymon-post.sh ${1} http://raspi4.local/solarprobe/api/xymon-report.sh xymon/extensions/generic.sh ${2} ${3} ${4}

