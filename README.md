# api-product-go


```sh
skaffold dev --port-forward  --trigger polling
```

```sh
curl http://localhost:8080/products

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
    
curl http://localhost:8080/products/1    
    
curl http://localhost:8080/products/1 \
    --include \
    --header "Content-Type: application/json" \
    --request "PUT" \
    --data '{"value": 11500.99}'    
    
curl http://localhost:8080/products/1 \
    --include \
    --header "Content-Type: application/json" \
    --request "DELETE"
    
```    

