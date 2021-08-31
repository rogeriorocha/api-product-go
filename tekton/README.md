## prepare env

* install tekton and dashboard

```sh
kubectl apply --filename https://storage.googleapis.com/tekton-releases/pipeline/latest/release.yaml

kubectl apply --filename https://github.com/tektoncd/dashboard/releases/latest/download/tekton-dashboard-release.yaml
```

*  port forward and open local

```sh
kubectl -n tekton-pipelines port-forward svc/tekton-dashboard 9097:9097
open http://localhost:9097
```

## add secret of dockerhub repository

- Opc 1 

```sh
# please, view if file $HOME/.docker/config.json content values of auth
kubectl create secret generic rpsr-dockerhub --from-file=.dockerconfigjson=$HOME/.docker/config.json --type=kubernetes.io/dockerconfigjson
```

- Opc 2
```sh
NAME="secret-rpsr-dockerhub"
SERVER="index.docker.io"
MYUSERNAME="rogeriosilvarocha"
PASSWORD="my-password"
DESTINATION="secret-rpsr-dockerhub.yaml"
NAMESPACE="default"

kubectl create secret docker-registry $NAME \
    --dry-run \
    --docker-server=$SERVER \
    --docker-username=$MYUSERNAME \
    --docker-password=$PASSWORD \
    --namespace=$NAMESPACE \
    -o yaml > $DESTINATION  
```

### add secret to sa 
kubectl edit sa default 
```