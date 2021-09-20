#!/usr/bin/env bash
#
#
# next version
# - argo rollout only working w port 3100

vkill=false
vstart=false

opens=(
  ''
  ''  
  ''
  'open http://localhost:PORT' 
  'open http://localhost:PORT'   
  'open http://localhost:PORT'     
)

cmds=(
  'istioctl dashboard prometheus -p PORT' 
  'istioctl dashboard grafana -p PORT' 
  'istioctl dashboard kiali -p PORT'
  'kubectl -n tekton-pipelines port-forward svc/tekton-dashboard PORT:9097'
  'kubectl -n argocd port-forward svc/argocd-server PORT:80'
  'kubectl argo rollouts dashboard -n prod'
)

ports=(9090 3000 20001 9097 8088 3100)
dscs=('Prometheus' 'Grafana' 'Kiali' 'Tekton' 'ArgoCD' 'Rollout')

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
  lsof -i :"$port" -sTCP:LISTEN |awk 'NR > 1 {print $2}' | uniq | xargs kill -15
}

killAll() {
  
  for (( i = 0; i < ${#dscs[@]}; ++i )); do
    #v=$((i+1))
    let "v=i+1"
    echo "${v}-${dscs[i]}:${ports[i]}..."
    kill ${ports[i]}
  done
}

args=("$@")
start() {
  dsc="$1"
  cmd="$2"
  port="$3"
  open="$4"

  dsc=`echo $dsc | sed -e 's/\"//g'`
  cmd=`echo $cmd | sed -e 's/\"//g'`
  port=`echo $port | sed -e 's/\"//g'`
  open=`echo $open | sed -e 's/\"//g'`

  printf "======> $dsc "
  #printf "CMD:$cmd \n"
  #printf "OPEN:$open \n"
   #printf "PORT:$port "
  
  #port=`echo $port | sed -e 's/\"//g'`
  
  exec="$(lsof -i :${port}|grep -i LISTEN|wc -l)" 
  
  if [[ "${exec}" -ge 1 ]]; then
    printf "in use -> http://localhost:${port}\n"
  else
    printf "starting...\n"
    run=$(echo "$cmd" | sed "s/PORT/$port/")
    #run=`echo $run | sed -e 's/\"//g'`
    ($run) &

    if ([[ ! -z "$open" ]]) ; then
      run=$(echo "$open" | sed "s/PORT/$port/")
      sleep 1
      ($run)
    fi
  fi
}

startAll() {
  for (( i = 0; i < ${#dscs[@]}; ++i )); do
      cmd=${cmds[i]}
      port=${ports[i]}
      dsc=${dscs[i]}
      open=${opens[i]}
      start "\"${dsc}\"" "\"${cmd}\"" "\"${port}\"" "\"${open}\"" 
      #if [[ "${i}" -ge 4 ]]; then
      #  exit;
      #fi
  done
}

if $vkill; then 
  printf "====================> Kill...\n"
  killAll service
fi
if $vstart; then 
  printf "====================> Start...\n"
  startAll
fi