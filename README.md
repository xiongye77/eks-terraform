# eks-terraform

After terraform apply finished (vpc and all eks cluster/nodes creation finished ), make sure run following command to add  new context arn:aws:eks:ap-southeast-2:996104769930:cluster/eks-test-cluster to /home/ec2-user/.kube/config 

aws eks update-kubeconfig --name eks-test-cluster 
