echo "Preparing environment..."

BASE=$(pwd)

read -p "Server: " SERVER

export BASE
export SERVER

envsubst < ${BASE}/client/client.conf.tmp   > ${BASE}/client/client.conf
envsubst < ${BASE}/config/base.conf.tmp     > ${BASE}/config/base.conf
envsubst < ${BASE}/config/probes.conf.tmp   > ${BASE}/config/probes.conf

echo "Done preparing environment."

