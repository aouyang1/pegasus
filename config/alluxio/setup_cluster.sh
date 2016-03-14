#!/bin/bash

# must be called from the top level

# check input arguments
if [ "$#" -ne 2 ]; then
    echo "Please specify pem-key location!" && exit 1
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

single_script="${PEG_ROOT}/config/alluxio/setup_single.sh"
args="${HOSTNAME_ARR[@]}"
# Install Alluxio on master and slaves
for dns in "${PUBLIC_DNS_ARR[@]}"
do
  run_script_on_node ${PEMLOC} ${dns} ${single_script} ${args} &
done

wait

format_script="${PEG_ROOT}/config/alluxio/format_fs.sh"
run_script_on_node ${PEMLOC} ${MASTER_DNS} ${format_script}

echo "Alluxio configuration complete!"
