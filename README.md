# kops-karpenter-poc

Building clusters

```
$ kops update cluster --yes --name=cluster.kops.tiagat.dev --state=s3://tiagat.kops-state
$ kops validate cluster --wait 10m --name=cluster.kops.tiagat.dev --state=s3://tiagat.kops-state
```

Destroy the cluster

```
$ terraform plan -destroy
$ terraform destroy
$ kops delete cluster --yes --name=cluster.kops.tiagat.dev --state=s3://tiagat.kops-state
```

Suggestions:

```
 * validate cluster: kops validate cluster --wait 10m
 * list nodes: kubectl get nodes --show-labels
 * ssh to a control-plane node: ssh -i ~/.ssh/id_rsa ubuntu@api.cluster.kops.tiagat.dev
 * the ubuntu user is specific to Ubuntu. If not using Ubuntu please use the appropriate user based on your OS.
 * read about installing addons at: https://kops.sigs.k8s.io/addons.
```

=======

kops create cluster \
 --name=cluster.kops.tiagat.dev \
 --state=s3://tiagat.kops-state \
 --dns-zone=kops.tiagat.dev \
 --zones=us-east-1a \
 --network-id=vpc-0624af06b169ba2ee \
 --subnets=subnet-06e9ef4c69a01c1f6 \
 --networking=calico \
 --control-plane-size=t3.micro \
 --node-size=t3.medium \
 --node-count=2 \
 --dns=public \
 --topology public
--yes

kops delete cluster --name=cluster.kops.tiagat.dev --state=s3://tiagat.kops-state --yes

kops validate cluster --wait 10m --name=cluster.kops.tiagat.dev --state=s3://tiagat.kops-state
kops export kubecfg --admin --name=cluster.kops.tiagat.dev --state=s3://tiagat.kops-state
