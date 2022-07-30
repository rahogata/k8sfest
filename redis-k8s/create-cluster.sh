#!/bin/bash
# Find ClusterIPs of Redis nodes
export REDIS_NODES=$(kubectl get pods  -l app=redis -n data -o json | jq -r '.items | map(.status.podIP) | join(":6379 ")'):6379
# Activate the Redis cluster
kubectl exec -it redis-0 -n data -- redis-cli --cluster create --cluster-replicas 1 ${REDIS_NODES} --cluster-yes
# Check if all went well
for x in $(seq 0 1); do echo "redis-$x"; kubectl exec redis-$x -n data -- redis-cli role; echo; done
