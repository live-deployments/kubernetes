tee -a cluster-config.yaml <<EOF
apiVersion: eksctl.io/v1alpha5
kind: ClusterConfig
metadata:
  name: test-eks-dpod
  region: ap-south-1
  version: "1.21"
vpc:
  id: vpc-08f9267eaa297caed
  subnets:
    public:
      public-1a:
        id: subnet-0a8d8e2cc8b57a407
      public-1b:
        id: subnet-073a880adba02ccd3
    private:
      private-1a:
        id: subnet-0c6d2a154508d8147
      private-1b:
        id: subnet-0a8cd8d6fdb0fbadc
managedNodeGroups:
  - name: ng-1
    amiFamily: AmazonLinux2
    instanceType: t2.medium
    ssh:
      publicKeyName: poc-dpod-kp
    desiredCapacity: 1
    minSize: 1
    maxSize: 5
    privateNetworking: true
    volumeSize: 20
    volumeType: gp3
    subnets:
      - private-1a
      - private-1b
    iam:
      attachPolicyARNs:
        - arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy
        - arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy
        - arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly
      withAddonPolicies:
        imageBuilder: true
        autoScaler: true
        certManager: true
        ebs: true
        albIngress: true
        cloudWatch: true
EOF
eksctl create cluster -f cluster-config.yaml
