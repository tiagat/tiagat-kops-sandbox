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
 --network-id=vpc-09d5a6e869bba813c \
 --subnets=subnet-0483eb59a6a7fae1d \
 --networking=calico \
 --node-count=3 \
 --control-plane-size=t3.micro \
 --node-size=t3.micro \
 --dns=public \
 --yes

kops delete cluster --name=cluster.kops.tiagat.dev --state=s3://tiagat.kops-state --yes

kops validate cluster --wait 10m --name=cluster.kops.tiagat.dev --state=s3://tiagat.kops-state
