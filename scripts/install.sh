#!/bin/sh

kubectl create -f deploy/service_account.yaml
kubectl create -f deploy/role.yaml
kubectl create -f deploy/role_binding.yaml
kubectl create -f deploy/crds/apm.nxrm.com_nxrms_crd.yaml
kubectl create -f deploy/operator.yaml
kubectl create -f deploy/crds/apm.nxrm.com_v1alpha1_nxrm_cr.yaml
