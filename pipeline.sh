#!/bin/bash

function drop {
  kubectl scale --replicas=0 "deployment/$1"
  kubectl delete deployment $1
  kubectl delete svc "$1-svc"
  kubectl delete pv "$1-pv"
  kubectl delete pvc "$1-pvc"
}

function apply {
  kubectl apply -f "./$1/k8s/all.yaml" --force
}

function build {
  docker build -t creativename/$1 ./$1
  docker push creativename/$1
  kubectl apply -f "./$1/k8s/all.yaml"
}

if [ -z "$1" ]; then
  echo "No project provided"
  exit 1
fi

if [ -z "$2" ]; then
  echo "No action provided"
  exit 1
fi

$2 $1
