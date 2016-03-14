#!/bin/bash

# check input arguments
if [ "$#" -ne 2 ]; then
    echo "Please specify pem-key location and cluster name!" && exit 1
fi

PEG_ROOT=$(dirname ${BASH_SOURCE})/../..
REGION=${AWS_DEFAULT_REGION:=us-west-2}

source ${PEG_ROOT}/util.sh

# get input arguments [aws region, pem-key location]
PEMLOC=$1
CLUSTER_NAME=$2

# check if pem-key location is valid
if [ ! -f $PEMLOC ]; then
  echo "pem-key does not exist!" && exit 1
fi

get_cluster_hostname_arr ${CLUSTER_NAME}
get_cluster_publicdns_arr ${CLUSTER_NAME}

MASTER_DNS=${PUBLIC_DNS_ARR[0]}

# Install HBase on master and slaves
single_script="${PEG_ROOT}/config/hbase/setup_single.sh"
args="$MASTER_DNS "${HOSTNAME_ARR[@]}""
for dns in "${PUBLIC_DNS_ARR[@]}"
do
  run_script_on_node ${PEMLOC} ${dns} ${single_script} ${args} &
done

wait

echo "HBase configuration complete!"
