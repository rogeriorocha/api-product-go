

### manual trigger invoke
```sh
chmod +x run-trigger-manual.sh
./run-trigger-manual.sh <COMMIT_ID>
```


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