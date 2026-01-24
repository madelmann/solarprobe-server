echo "Preparing environment..."

BASE=$(pwd)

export BASE

envsubst < ${BASE}/config/base.conf.tmp     > ${BASE}/config/base.conf
envsubst < ${BASE}/config/probes.conf.tmp   > ${BASE}/config/probes.conf


echo "Done preparing environment."

