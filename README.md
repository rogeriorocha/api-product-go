# About
DevOps Cloud-native CI/CD GitOps with Tekton & ArgoCD.

write REST API sample in ***golang***.

![](https://img.shields.io/github/last-commit/rogeriorocha/api-product-go)

![](https://img.shields.io/github/commit-activity/m/rogeriorocha/api-product-go)

## ⚡ Technologies
![Tekton](https://img.shields.io/badge/-Tekton-FD495C?style=flat-square&logo=tekton&logoColor=white)
![ArgoCD](https://img.shields.io/badge/-Argo%20CD-red?style=flat-square&logo=argocd&logoColor=white)

* Others

![Kubernetes](https://img.shields.io/badge/-Kubernetes-blue?style=flat-square&logo=kubernetes&logoColor=white)
![Docker](https://img.shields.io/badge/-Docker-white?style=flat-square&logo=docker&logoColor=blue)
![Golang](https://img.shields.io/badge/-GO-white?style=flat-square&logo=go&logoColor=311C87)
![MySQL](https://img.shields.io/badge/-MySQL-black?style=flat-square&logo=mysql)
![GitHub](https://img.shields.io/badge/-GitHub-181717?style=flat-square&logo=github)


## Requirements:
- [Tekton](https://tekton.dev/) - CI/CD
- [ArgoCD](https://argoproj.github.io/argo-cd/) - GitOps 
- [Argo Rollouts](https://argoproj.github.io/argo-rollouts/) - Rollouts
- [Kubernetes Cluster](https://kubernetes.io/docs/concepts/overview/what-is-kubernetes/) (eg [k3d](https://k3d.io/) local cluster)
- kubectl CLI
- [Docker](https://www.docker.com/) - Container

- [Skaffold (Opc)](https://skaffold.dev/) - Local Kubernetes Development


### versions
#### Tekton Pipeline/Trigger/Dashboard
```sh
tkn version

Client version: 0.20.0
Pipeline version: v0.27.3
Triggers version: v0.16.0
Dashboard version: v0.19.0
```

#### Kubernetes
```sh
kubectl version -o yaml

clientVersion:
  buildDate: "2021-04-08T16:31:21Z"
  compiler: gc
  gitCommit: cb303e613a121a29364f75cc67d3d580833a7479
  gitTreeState: clean
  gitVersion: v1.21.0
  goVersion: go1.16.1
  major: "1"
  minor: "21"
  platform: darwin/amd64
serverVersion:
  buildDate: "2021-08-17T02:06:07Z"
  compiler: gc
  gitCommit: 4966fd0dded6419fd23233a38c8905c67a3ea78e
  gitTreeState: clean
  gitVersion: v1.20.7
  goVersion: go1.15.12
  major: "1"
  minor: "20"
  platform: linux/amd64
```  

#### ArgoCD / Rollout
```sh
argocd version

argocd: v2.0.5+4c94d88.dirty
  BuildDate: 2021-07-23T05:12:02Z
  GitCommit: 4c94d886f56bcb2f9d5b3251fdc049c2d1354b88
  GitTreeState: dirty
  GoVersion: go1.16.6
  Compiler: gc
  Platform: darwin/amd64
argocd-server: v2.1.1+aab9542
```

```sh
kubectl argo rollouts version

  kubectl-argo-rollouts: v1.0.4+c63b6c1
  BuildDate: 2021-08-03T02:45:19Z
  GitCommit: c63b6c1f5134a9f19caae37765f1a8a145f62d7d
  GitTreeState: clean
  GoVersion: go1.16.3
  Compiler: gc
  Platform: darwin/amd64
```  


## services
* ***api*** REST;
* ***mySql*** database.
 
### Start Skaffold deploy
```shell=
skaffold dev --port-forward  --trigger polling
```

### methods

* Set API_URL
```shell=
export API_URL="http://localhost:8080/api/v1/products"
```

* ***get*** ALL products
```shell=
curl $API_URL
```

* ***post*** add one product
```shell=
curl $API_URL \
    --include \
    --header "Content-Type: application/json" \
    --request "POST" \
    --data '{"id": "1","name": "bike","value": 4009.99}'

curl $API_URL \
    --include \
    --header "Content-Type: application/json" \
    --request "POST" \
    --data '{"id": "2","name": "ebook x","value": 5.00}'

curl $API_URL \
    --include \
    --header "Content-Type: application/json" \
    --request "POST" \
    --data '{"id": "3","name": "Server z","value": 90000.00}'
````
* ***get*** ONE product
```shell=
curl $API_URL/1

````
* ***put*** change ONE product
```shell=
curl $API_URL/1 \
    --include \
    --header "Content-Type: application/json" \
    --request "PUT" \
    --data '{"value": 11500.99}'    
````
* ***delete*** ONE product
```shell=
curl $API_URL/1 \
    --include \
    --header "Content-Type: application/json" \
    --request "DELETE"
    
```
