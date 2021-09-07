# About
Sample REST API in ***golang***.

![](https://img.shields.io/github/last-commit/rogeriorocha/api-product-go)

![](https://img.shields.io/github/commit-activity/m/rogeriorocha/api-product-go)

<!--
## ⚡ Technologies
![Tekton](https://img.shields.io/badge/-Tekton-FD495C?style=flat-square&logo=tekton&logoColor=white)

![ArgoCD](https://img.shields.io/badge/-Argo-red?style=flat-square&logo=argocd&logoColor=white)

![Kubernetes](https://img.shields.io/badge/-Kubernetes-blue?style=flat-square&logo=kubernetes&logoColor=white)
![Docker](https://img.shields.io/badge/-Docker-white?style=flat-square&logo=docker&logoColor=blue)
![Golang](https://img.shields.io/badge/-GO-white?style=flat-square&logo=go&logoColor=311C87)
![MySQL](https://img.shields.io/badge/-MySQL-black?style=flat-square&logo=mysql)

![GitHub](https://img.shields.io/badge/-GitHub-181717?style=flat-square&logo=github)
-->


## Requirements:
- [Skaffold](https://skaffold.dev/) - Local Kubernetes Development
- [Kubernetes Cluster](https://kubernetes.io/docs/concepts/overview/what-is-kubernetes/) (eg [k3d](https://k3d.io/) local cluster)
- [Docker](https://www.docker.com/) - Container
- kubectl CLI




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
