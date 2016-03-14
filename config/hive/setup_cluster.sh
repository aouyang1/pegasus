#!/bin/bash

# check input arguments
if [ "$#" -ne 2 ]; then
    echo "Please specify the pem-key location and cluster name" && exit 1
fi

PEG_ROOT=$(dirname ${BASH_SOURCE})/../..
REGION=${AWS_DEFAULT_REGION:=us-west-2}

source ${PEG_ROOT}/util.sh

PEMLOC=$1
CLUSTER_NAME=$2

# check if pem-key location is valid
if [ ! -f $PEMLOC ]; then
    echo "pem-key does not exist!" && exit 1
fi

get_cluster_publicdns_arr ${CLUSTER_NAME}

MASTER_DNS=${PUBLIC_DNS_ARR[0]}

single_script="${PEG_ROOT}/config/hive/setup_hive.sh"
run_script_on_node ${PEMLOC} ${MASTER_DNS} ${single_script}

