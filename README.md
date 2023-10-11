# kops-karpenter-poc

Building clusters

```
$ kops update cluster --yes --name=sandbox.tiagat.dev --state=s3://tiagat.kops-state
$ kops validate cluster --wait 10m --name=sandbox.tiagat.dev --state=s3://tiagat.kops-state
```

Destroy the cluster

```
$ terraform plan -destroy
$ terraform destroy
$ kops delete cluster --yes --name=sandbox.tiagat.dev --state=s3://tiagat.kops-state
```

Suggestions:

```
 * validate cluster: kops validate cluster --wait 10m
 * list nodes: kubectl get nodes --show-labels
 * ssh to a control-plane node: ssh -i ~/.ssh/id_rsa ubuntu@api.cluster.kops.tiagat.dev
 * the ubuntu user is specific to Ubuntu. If not using Ubuntu please use the appropriate user based on your OS.
 * read about installing addons at: https://kops.sigs.k8s.io/addons.
```

kops delete cluster --name=sandbox.tiagat.dev --state=s3://tiagat.kops-state --yes

kops validate cluster --wait 10m --name=sandbox.tiagat.dev --state=s3://tiagat.kops-state
AWS_PROFILE=tiagat kops export kubecfg --admin --name=sandbox.tiagat.dev --state=s3://tiagat.kops-state --kubeconfig ~/.kube/tiagat-sandbox
