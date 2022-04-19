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

# in case if you want to delete the iam-oidc-provider

OIDCURL=$(aws eks describe-cluster --name $CLUSTER_NAME --output json | jq -r .cluster.identity.oidc.issuer | sed -e "s*https://**")
aws iam delete-open-id-connect-provider --open-id-connect-provider-arn arn:aws:iam::$ACCOUNT_ID:oidc-provider/$OIDCURL

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


# in case if you want to delete iamserviceaccount  
[ec2-user@ip-192-168-20-103 terraform-eks]$  eksctl delete iamserviceaccount --cluster eks-cluster  --name aws-load-balancer-controller --namespace=kube-system

2022-04-19 00:37:41 [ℹ]  eksctl version 0.74.0
2022-04-19 00:37:41 [ℹ]  using region ap-southeast-2
2022-04-19 00:37:42 [ℹ]  1 iamserviceaccount (kube-system/aws-load-balancer-controller) was included (based on the include/exclude rules)
2022-04-19 00:37:42 [ℹ]  1 task: {
    2 sequential sub-tasks: {
        delete IAM role for serviceaccount "kube-system/aws-load-balancer-controller" [async],
        delete serviceaccount "kube-system/aws-load-balancer-controller",
    } }2022-04-19 00:37:42 [ℹ]  will delete stack "eksctl-eks-cluster-addon-iamserviceaccount-kube-system-aws-load-balancer-controller"
2022-04-19 00:37:43 [ℹ]  serviceaccount "kube-system/aws-load-balancer-controller" was already deleted


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
  
  helm ls  -n kube-system

NAME                            NAMESPACE       REVISION        UPDATED                                 STATUS          CHART                                   APP VERSION
aws-load-balancer-controller    kube-system     1               2022-04-19 00:14:34.759154489 +0000 UTC deployed        aws-load-balancer-controller-1.4.1      v2.4.1

  
  kubectl -n kube-system get svc
  kubectl -n kube-system get pods
  kubectl -n kube-system logs -f  aws-load-balancer-controller-58df4cd9dd-fxhdm
  
 # You can use code in cicd-codecommit-codebuild folder to create codecommit repo and codebuild project (buildspec.yml),linked them together use codepipeline.
 ![image](https://user-images.githubusercontent.com/36766101/162945405-d805e15f-14d6-453a-8916-a941cdfc6f0c.png)

 
 # if you want to use AWS codebuild for run EKS deployment tasks, when run command such as kubectl get nodes at Codebuild, maybe get error.
 Make sure you check following link if you met issue "error: You must be logged in to the server (Unauthorized)"
 https://aws.amazon.com/premiumsupport/knowledge-center/codebuild-eks-unauthorized-errors/
 
 
 # create ingress class
 kubectl apply -f 01-ingressclass-resource.yaml
 
