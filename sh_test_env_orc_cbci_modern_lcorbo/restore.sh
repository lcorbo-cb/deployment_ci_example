#!/usr/bin/env bash

kubectl --namespace=cloudbees-core get pods cjoc-0 -o jsonpath='{.spec.securityContext}'

#map[fsGroup:1000]

kubectl --namespace=cloudbees-core scale statefulset/cjoc --replicas=1

#statefulset.apps "cjoc" scaled

kubectl --namespace=cloudbees-core get pvc

# NAME                          STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   AGE
# jenkins-home-cjoc-0           Bound    pvc-2943695b-e0cb-4f44-8f63-1737fa6241fa   20Gi       RWO            standard       3h24m
# jenkins-home-master01-0       Bound    pvc-1a702004-9212-4747-9800-b2f9038ddbc3   50Gi       RWO            standard       3h7m
# jenkins-home-master02-0       Bound    pvc-701f0a51-f117-40c3-9447-56d806bf7e5f   50Gi       RWO            standard       3h7m
# jenkins-home-teams-team01-0   Bound    pvc-f5972ff9-fec3-4350-b5d0-665174f622aa   50Gi       RWO            standard       3h
# jenkins-home-teams-team02-0   Bound    pvc-f637ace5-0803-4ee3-90ae-68d5dc5fbc40   50Gi       RWO            standard       3
