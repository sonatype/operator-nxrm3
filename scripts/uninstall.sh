#!/bin/sh

kubectl delete -f deploy/crds/apm.nxrm.com_v1alpha1_nxrm_cr.yaml
kubectl delete -f deploy/operator.yaml
kubectl delete -f deploy/crds/apm.nxrm.com_nxrms_crd.yaml
kubectl delete -f deploy/role.yaml
kubectl delete -f deploy/role_binding.yaml
kubectl delete -f deploy/service_account.yaml
