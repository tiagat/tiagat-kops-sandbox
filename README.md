# kops-karpenter-poc

Building clusters

```
$ export KOPS_STATE_STORE=s3://tiagat.kops-state
```

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
kops export kubecfg --admin --name=sandbox.tiagat.dev --state=s3://tiagat.kops-state

===============

Karpenter:

1. export KOPS_FEATURE_FLAGS="Karpenter"
2. set `autoscale = false` for `kops_instance_group`
3. create new `kops_instance_group` with `manager = "Karpenter"`
4. enable kOps addon `karpenter {  enabled = true }` for `kops_cluster`

DELETE
$ kops delete cluster --name=sandbox.tiagat.dev --state=s3://tiagat.kops-state --yes
$ terraform state rm kops_cluster.cluster
$ terraform state rm kops_instance_group.master
$ terraform state rm kops_instance_group.node
$ terraform state rm module.kubernetes
$ aws s3 rm s3://tiagat.kops-state/sandbox.tiagat.dev --recursive
