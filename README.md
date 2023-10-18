# kops-karpenter-poc

Building clusters (manual)

```
$ export KOPS_STATE_STORE=s3://tiagat-kops-state
$ export KOPS_FEATURE_FLAGS="Karpenter"
```

```
$ kops update cluster --yes --name=sandbox.tiagat.dev --state=s3://tiagat-kops-state
$ kops export kubeconfig --name=sandbox.tiagat.dev --admin --state=s3://tiagat-kops-state
$ kops validate cluster --wait 10m --name=sandbox.tiagat.dev --state=s3://tiagat-kops-state
```

Destroy the cluster

```
$ terraform plan -destroy
$ terraform destroy
$ kops delete cluster --yes --name=sandbox.tiagat.dev --state=s3://tiagat-kops-state
```

Destroy the cluster (partial)

```
$ kops delete cluster --name=sandbox.tiagat.dev --state=s3://tiagat-kops-state --yes
$ terraform state rm kops_cluster.cluster
$ terraform state rm kops_instance_group.master
$ terraform state rm kops_instance_group.node
$ terraform state rm module.kubernetes
$ aws s3 rm s3://tiagat-kops-state/sandbox.tiagat.dev --recursive
```
