# eks-terraform

After terraform apply finished (vpc and all eks cluster/nodes creation finished ), make sure run following command to add  new context arn:aws:eks:ap-southeast-2:996104769930:cluster/eks-test-cluster to /home/ec2-user/.kube/config 

aws eks update-kubeconfig --name eks-test-cluster 





# Create IAM Policy using policy downloaded 

curl -o iam_policy_latest.json https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/main/docs/install/iam_policy.json
aws iam create-policy \
    --policy-name AWSLoadBalancerControllerIAMPolicy \
    --policy-document file://iam_policy_latest.json
    
# verify sa not exist in kube-system namespace

kubectl get sa aws-load-balancer-controller -n kube-system

# create IAM OIDC provider associated with cluster
eksctl utils associate-iam-oidc-provider --region=ap-southeast-2 --cluster=eks-test-cluster  --approve


# create iamserviceaccount 

eksctl create iamserviceaccount \
  --cluster=eks-test-cluster \
  --namespace=kube-system \
  --name=aws-load-balancer-controller \
  --attach-policy-arn=arn:aws:iam::996104769930:policy/AWSLoadBalancerControllerIAMPolicy \
  --override-existing-serviceaccounts \
  --approve
  
  
# verify iamserviceaccount creation finished 
eksctl  get iamserviceaccount --cluster eks-test-cluster


2022-04-11 07:01:16 [ℹ]  eksctl version 0.74.0

2022-04-11 07:01:16 [ℹ]  using region ap-southeast-2
NAMESPACE       NAME                            ROLE ARN
kube-system     aws-load-balancer-controller    arn:aws:iam::996104769930:role/eksctl-eks-test-cluster-addon-iamserviceacco-Role1-1RN1BJRQS2ZZ8


 kubectl get sa aws-load-balancer-controller -n kube-system
 
 
 
 # Install AWS Load Balancer Controller
 helm repo add eks https://aws.github.io/eks-charts
 
 helm repo update
 
 helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set clusterName=eks-test-cluster \
  --set serviceAccount.create=false \
  --set serviceAccount.name=aws-load-balancer-controller \
  --set region=ap-southeast-2 \
  --set vpcId=vpc-0ef551cc525ec3dcf \
  --set image.repository=602401143452.dkr.ecr.us-east-1.amazonaws.com/amazon/aws-load-balancer-controller
  
  # verify using following commands
  
  helm list --all-namespaces
  
  
  kubectl -n kube-system get svc
  kubectl -n kube-system get pods
  kubectl -n kube-system logs -f  aws-load-balancer-controller-58df4cd9dd-fxhdm
  
 
 # create ingress class
 kubectl apply -f 01-ingressclass-resource.yaml
 
