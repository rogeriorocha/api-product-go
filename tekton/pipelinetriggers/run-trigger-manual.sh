#!/bin/bash


commitId=$1

echo commit-id=$commitId


data="{\"ref\": \"refs/heads/main\", \"head_commit\": {\"id\":\"$commitId\"}}"

echo $data

sig=$(echo -n "${data}" | openssl dgst -sha1 -hmac "123" | awk '{print "X-Hub-Signature: sha1="$1}')

echo SIG=$sig

curl -i \
  -H 'X-GitHub-Event: push' \
  -H "${sig}" \
  -H 'Content-Type: application/json' \
  -H 'Host: tekton-triggers.example.com' \
  --data "${data}" \
  http://localhost:8088
