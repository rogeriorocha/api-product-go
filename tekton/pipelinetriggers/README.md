
data="{\"ref\": \"${refname}\"}"
data="{\"ref\": \"refs/heads/main\", \"head_commit\": {\"id\":\"55bff425ee4ac15d90030a8e117d9875b5d8822b\"}}"


sig=$(echo -n "${data}" | openssl dgst -sha1 -hmac "123" | awk '{print "X-Hub-Signature: sha1="$1}')


curl -i \
  -H 'X-GitHub-Event: push' \
  -H "${sig}" \
  -H 'Content-Type: application/json' \
  -H 'Host: tekton-triggers.example.com' \
  --data "${data}" \
  http://localhost:8088



curl -i \
  -H 'X-GitHub-Event: push' \
  -H sig 
  -H 'X-Hub-Signature: sha1=123' \
  -H 'Content-Type: application/json' \
  -H 'Host : http://tekton-triggers.example.com' \
  -d '{"ref":"refs/heads/main","head_commit":{"id":"123abc..."}}' \
  http://localhost:8088/


E0907 16:48:47.766814       1 reflector.go:138] runtime/asm_amd64.s:1371: Failed to watch *v1alpha1.ClusterInterceptor: failed to list *v1alpha1.ClusterInterceptor: clusterinterceptors.triggers.tekton.dev is forbidden: User "system:serviceaccount:tekton-pipelines:tekton-github-triggers" cannot list resource "clusterinterceptors" in API group "triggers.tekton.dev" at the cluster scop