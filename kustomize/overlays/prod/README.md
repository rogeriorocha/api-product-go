curl -i -H 'Host: prod.api.com' http://localhost:8088/api/api/v1/products


    sum(irate(
            istio_requests_total{reporter="source",destination_service=~"api-service.prod.svc.cluster.local",response_code!~"5.*"}[5m]
          )) / 
          sum(irate(
            istio_requests_total{reporter="source",destination_service=~"api-service.prod.svc.cluster.local"}[5m]
          ))


api-service.prod.svc.cluster.local

irate(istio_requests_total{reporter="source",destination_service=~"api-service.prod.svc.cluster.local"}[2m] )