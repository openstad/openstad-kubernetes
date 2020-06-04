#!/bin/bash

kubectl -n openstad apply -f secret/ 
kubectl -n openstad apply -f deployment/ 
