#!/bin/sh

kubectl apply -f deploy/service_account.yaml
kubectl apply -f deploy/role.yaml
kubectl apply -f deploy/role_binding.yaml
kubectl apply -f deploy/crds/sonatype.com_nexusrepos_crd.yaml
kubectl apply -f deploy/operator.yaml
kubectl apply -f deploy/crds/sonatype.com_v1alpha1_nexusrepo_cr.yaml
