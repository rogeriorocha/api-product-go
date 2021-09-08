### port-forward ingress
```sh
kubectl -n istio-system port-forward svc/istio-ingressgateway 8088:80
```

### manual trigger invoke
```sh
chmod +x run-trigger-manual.sh
./run-trigger-manual.sh <COMMIT_ID>
```
