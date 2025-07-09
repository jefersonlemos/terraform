# How to use the module



# Setting up kubectl

aws eks

adjust kube config

 exec:
      apiVersion: client.authentication.k8s.io/v1beta1
      args:
      - --region
      - us-east-1
      - eks
      - get-token
      - --role-arn
      - arn:aws:iam::443370700365:role/EKSAdmin-role
      - --cluster-name
      - poc-spring-boot-app-dev
      - --output
      - json
      command: aws


