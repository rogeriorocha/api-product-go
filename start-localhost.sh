#!/bin/bash

#set -e

vkill=false
vstart=false

function show_usage (){
    printf "Usage: $0 [options [parameters]]\n"
    printf "\n"
    printf "Options:\n"
    printf " -s|--start  start \n"
    printf " -k|--kill   kill\n"    
    printf " -h|--help, Print help\n"

return 0
}

if [[ "$1" == "--help" ]] || [[ "$1" == "-h" ]];then
    show_usage
    exit 0
fi

while [ ! -z "$1" ]; do
  case "$1" in
     --start|-s)
         shift
         vstart=true
         #echo "start: $1"
         ;;
     --kill|-k)
         shift
         vkill=true
         #echo "kill: $1"
         ;;
     --number|-n)
         shift
         echo "You entered number as: $1"
         ;;
     --collect|-c)
         shift
         echo "You entered collect as: $1"
         ;;
     --timeout|-t)
        shift
        echo "You entered timeout as: $1"
         ;;
     *)
        printf "Error, parameter not found...\n"
        show_usage
        exit 1
        ;;
  esac
shift
done

kill() {
  port=$1
  echo "port=${port}"
  lsof -i :"$port" -sTCP:LISTEN |awk 'NR > 1 {print $2}' | uniq | xargs kill -15
}

killAll() {
  arPort=( 3000 9090 8088 9097 20001 3100)
  for i in "${arPort[@]}"
  do
    kill $i
  done
}

startAll() {
  # ===== Tekton
  port=9097
  app="Tekton"
  a="$(lsof -i :${port}|grep -i LISTEN|wc -l)"
  #echo "${a}"
  if [[ "${a}" -ge 2 ]]; then
    echo "${app}:${port} in use -> http://localhost:${port}"
  else
    echo "${app} ${port} not"
    kubectl -n tekton-pipelines port-forward svc/tekton-dashboard 9097:9097 &
    sleep 2
    open http://localhost:9097
  fi
  # ======= KIALI
  port=20001
  app="Kialli"
  a="$(lsof -i :${port}|grep -i LISTEN|wc -l)"
  if [[ "${a}" -ge 2 ]]; then
    echo "${app}:${port} in use -> http://localhost:${port}"
  else
    echo "${app}:${port} starting..."
    istioctl dashboard kiali &
  fi
  #=======  Argo Rollouts
  app="Argo rollout"
  port=3100
  a="$(lsof -i :${port}|grep -i LISTEN|wc -l)"
  if [[ "${a}" -ge 1 ]]; then
    echo "${app}:${port} in use -> http://localhost:${port}"
  else
    echo "${app}:${port} starting..."
    kubectl argo rollouts dashboard -n prod &
    sleep 2
    open http://localhost:3100
  fi
  #=======  Argo CD GitOps
  app="Argo CD GitOps"
  port=8088
  a="$(lsof -i :${port}|grep -i LISTEN|wc -l)"
  if [[ "${a}" -ge 1 ]]; then
    echo "${app}:${port} in use -> http://localhost:${port}"
  else
    echo "${app}:${port} starting..."
    kubectl -n argocd port-forward svc/argocd-server 8088:80 &
    sleep 2
    open http://localhost:8088
  fi
  #=======  Prometheus
  app="Prometheus"
  port=9090
  a="$(lsof -i :${port}|grep -i LISTEN|wc -l)"
  if [[ "${a}" -ge 1 ]]; then
    echo "${app}:${port} in use -> http://localhost:${port}"
  else
    echo "${app}:${port} starting..."
    istioctl dashboard prometheus &
  fi
  #=======  Grafana
  app="Grafana"
  port=3000
  a="$(lsof -i :${port}|grep -i LISTEN|wc -l)"
  if [[ "${a}" -ge 1 ]]; then
    echo "${app}:${port} in use -> http://localhost:${port}"
  else
    echo "${app}:${port} starting..."
    istioctl dashboard grafana &
  fi
}

if $vkill; then 
  printf "===== Kill...\n"
  killAll
fi
if $vstart; then 
  printf "===== Start...\n"
  startAll
fi