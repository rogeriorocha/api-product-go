# About
Sample REST API in ***golang***.

## Requirements:
- [Skaffold](https://skaffold.dev/) - Local Kubernetes Development
- [Kubernetes Cluster](https://kubernetes.io/docs/concepts/overview/what-is-kubernetes/) (eg [k3d](https://k3d.io/) local cluster)
- [Docker](https://www.docker.com/) - Container
- kubectl CLI





## services
* ***api*** REST;
* ***mySql*** database.
 
### Start Skaffold deploy
```sh
skaffold dev --port-forward  --trigger polling
```

### methods

* ***get*** ALL products
```sh
curl http://localhost:8080/products
```

* ***post*** add one product
```sh
curl http://localhost:8080/products \
    --include \
    --header "Content-Type: application/json" \
    --request "POST" \
    --data '{"id": "1","name": "bike","value": 4009.99}'

curl http://localhost:8080/products \
    --include \
    --header "Content-Type: application/json" \
    --request "POST" \
    --data '{"id": "2","name": "ebook x","value": 5.00}'

curl http://localhost:8080/products \
    --include \
    --header "Content-Type: application/json" \
    --request "POST" \
    --data '{"id": "3","name": "Server z","value": 90000.00}'
````
* ***get*** ONE product
```sh
curl http://localhost:8080/products/1    

````
* ***put*** change ONE product
```sh
curl http://localhost:8080/products/1 \
    --include \
    --header "Content-Type: application/json" \
    --request "PUT" \
    --data '{"value": 11500.99}'    
````
* ***delete*** ONE product
```sh
curl http://localhost:8080/products/1 \
    --include \
    --header "Content-Type: application/json" \
    --request "DELETE"
    
```
