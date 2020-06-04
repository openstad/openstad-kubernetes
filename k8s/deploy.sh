#!/bin/bash

kubectl -n openstad apply -f secret/ 
kubectl -n openstad apply -f configmap/ 
kubectl -n openstad apply -f deployment/ 
kubectl -n openstad apply -f service/