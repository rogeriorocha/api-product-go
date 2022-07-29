### create cluster K8S GCP
project_id=ex-demo-001
cluster_name=argocd-1

gcloud projects create $project_id
#set default project
gcloud config set project $project_id
# REMEMBER: Enable Billing and Enable Kubernetes Engine API if not...
# $ gcloud services enable container.googleapis.com
gcloud beta container --project $project_id clusters create $cluster_name --zone "us-east1-b" --no-enable-basic-auth --cluster-version "1.22.8-gke.202" --release-channel "regular" --machine-type "e2-medium" --image-type "COS_CONTAINERD" --disk-type "pd-standard" --disk-size "100" --metadata disable-legacy-endpoints=true --scopes "https://www.googleapis.com/auth/devstorage.read_only","https://www.googleapis.com/auth/logging.write","https://www.googleapis.com/auth/monitoring","https://www.googleapis.com/auth/servicecontrol","https://www.googleapis.com/auth/service.management.readonly","https://www.googleapis.com/auth/trace.append" --max-pods-per-node "110" --num-nodes "4" --logging=SYSTEM,WORKLOAD --monitoring=SYSTEM --enable-ip-alias --network "projects/$project_id/global/networks/default" --subnetwork "projects/$project_id/regions/us-east1/subnetworks/default" --no-enable-intra-node-visibility --default-max-pods-per-node "110" --no-enable-master-authorized-networks --addons HorizontalPodAutoscaling,HttpLoadBalancing,GcePersistentDiskCsiDriver --enable-autoupgrade --enable-autorepair --max-surge-upgrade 1 --max-unavailable-upgrade 0 --enable-shielded-nodes --node-locations "us-east1-b"

#DELETE GKE
#gcloud beta container --project $project_id clusters delete $cluster_name --zone "us-east1-b" 

### install istio
# https://istio.io/latest/docs/setup/install/helm/


helm repo add istio https://istio-release.storage.googleapis.com/charts
helm repo update

kubectl create namespace istio-system
helm install istio-base istio/base -n istio-system
helm install istiod istio/istiod -n istio-system --wait

# ingress
kubectl create namespace istio-ingress
kubectl label namespace istio-ingress istio-injection=enabled
helm install istio-ingress istio/gateway -n istio-ingress --wait


### install argocd
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

kubectl -n argocd port-forward svc/argocd-server 8088:80

psw=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo)
argocd login localhost:8088 --insecure --username admin --password $psw
#user admin
echo $psw
argocd account update-password

### install argo-rollouts 
#   https://argoproj.github.io/argo-rollouts/installation/
kubectl create namespace argo-rollouts
kubectl apply -n argo-rollouts -f https://github.com/argoproj/argo-rollouts/releases/latest/download/install.yaml


### configure argo app sample

argocd repo add git@github.com:rogeriorocha/api-product-go.git --ssh-private-key-path ~/.ssh/id_rsa_argocd_demo
#if necessary change type => ssh-keygen -t ecdsa -b 521 -C "rogeriosilvarocha@gmail.com"
argocd app create api-product-prod --repo git@github.com:rogeriorocha/api-product-go.git \
   --path kustomize/overlays/prod --dest-namespace prod --dest-server https://kubernetes.default.svc


### Test Rollout
#GitOPS in kustomize/overlays/prod
kustomize edit set image rogeriosilvarocha/api=rogeriosilvarocha/api:2.0
git add kustomization.yaml
git commit -m "[Rogerio Rocha] change image ..."
git push -u origin main

# pipeline update app
#argocd app sync api-product-prod --insecure
argocd app wait api-product-prod --sync --health --operation --insecure

# apply ro
kubectl argo rollouts set image api "*=rogeriosilvarocha/api:0.4" -n prod



# view vs weight changing
watch -n 1 "kubectl -n prod get vs api-vs -o yaml | yq '.spec.http[0].route'"
kubectl argo rollouts get rollout api --watch -n prod


### install prometheus
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
#helm search repo prometheus-community
helm install prometheus-community/kube-prometheus-stack --namespace prometheus --generate-name


### istio DEMO install
curl -L https://istio.io/downloadIstio | sh -
cd istio...
export PATH=$PWD/bin:$PATH

istioctl install --set profile=demo -y


### enable prometheus
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.14/samples/addons/prometheus.yaml
kubectl -n istio-system  port-forward svc/prometheus 9090:9090


###
