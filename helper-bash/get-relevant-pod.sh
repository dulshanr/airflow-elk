#!/bin/bash

# get node name of passed pod
pod_arg=$1
pod_id="$(kubectl get pods -n dataplatform | grep $pod_arg | awk '{print $1}')"
node_of_pod=$(kubectl get pod $pod_id -n dataplatform -o jsonpath='{.spec.nodeName}')


LSL=$(kubectl get pods -n dataplatform | grep fluent-bit | awk '{print $1}')



# iterate fluentbit or filebeat pods
declare -a MYRA
MYRA=($LSL)

for item in "${MYRA[@]}"
do
    stm="kubectl get pod $item -n dataplatform -o=jsonpath='{.spec.affinity.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[0].matchFields[0].values[0]}'"
    exec_stm=$($stm)
    exec_stm="${exec_stm:1:-1}"
    if [ $exec_stm == $node_of_pod ]
    then
        echo -e "podname: $item \t node:$exec_stm"
    fi
done


