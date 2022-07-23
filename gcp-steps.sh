project_id=ex-argocd-001
cluster_name=cluster-1


gcloud projects create $project_id

# Enable Kubernetes Engine API
gcloud beta container --project $project_id clusters create $cluster_name --zone "us-east1-b" --no-enable-basic-auth --cluster-version "1.22.8-gke.202" --release-channel "regular" --machine-type "e2-medium" --image-type "COS_CONTAINERD" --disk-type "pd-standard" --disk-size "100" --metadata disable-legacy-endpoints=true --scopes "https://www.googleapis.com/auth/devstorage.read_only","https://www.googleapis.com/auth/logging.write","https://www.googleapis.com/auth/monitoring","https://www.googleapis.com/auth/servicecontrol","https://www.googleapis.com/auth/service.management.readonly","https://www.googleapis.com/auth/trace.append" --max-pods-per-node "110" --num-nodes "4" --logging=SYSTEM,WORKLOAD --monitoring=SYSTEM --enable-ip-alias --network "projects/$project_id/global/networks/default" --subnetwork "projects/$project_id/regions/us-east1/subnetworks/default" --no-enable-intra-node-visibility --default-max-pods-per-node "110" --no-enable-master-authorized-networks --addons HorizontalPodAutoscaling,HttpLoadBalancing,GcePersistentDiskCsiDriver --enable-autoupgrade --enable-autorepair --max-surge-upgrade 1 --max-unavailable-upgrade 0 --enable-shielded-nodes --node-locations "us-east1-b"

#
#gcloud beta container --project $project_id clusters delete $cluster_name --zone "us-east1-b" 


### Install ISTIO
https://istio.io/latest/docs/setup/install/helm/


helm repo add istio https://istio-release.storage.googleapis.com/charts
helm repo update

kubectl create namespace istio-system
helm install istio-base istio/base -n istio-system
helm install istiod istio/istiod -n istio-system --wait

#argocd
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/v2.3.5/manifests/install.yaml

psw=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo)

kubectl -n argocd port-forward svc/argocd-server 8088:80
argocd login localhost:8088
#user admin
argocd account update-password

argocd repo add git@github.com:rogeriorocha/api-product-go.git --ssh-private-key-path ~/.ssh/id_rsa
#if necessary change type => ssh-keygen -t ecdsa -b 521 -C "rogeriosilvarocha@gmail.com"

### argo-rollouts
# https://argoproj.github.io/argo-rollouts/installation/
kubectl create namespace argo-rollouts
kubectl apply -n argo-rollouts -f https://github.com/argoproj/argo-rollouts/releases/latest/download/install.yaml

argocd app create api-product-prod --repo git@github.com:rogeriorocha/api-product-go.git --path kustomize/overlays/prod --dest-namespace prod --dest-server https://kubernetes.default.svc

#in kustomize/overlays/prod
kustomize edit set image rogeriosilvarocha/api=rogeriosilvarocha/api:2.0
git add kustomization.yaml
git commit -m "[Rogerio Rocha] change image"
git push -u origin main


# pipeline update app
argocd app sync api-product-prod --insecure
argocd app wait api-product-prod --sync --health --operation --insecure

# view vs weight changing
watch -n 1 "kubectl -n prod get vs api-vs -o yaml | yq '.spec.http[0].route'"
kubectl argo rollouts get rollout api --watch -n prod