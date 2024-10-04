apiVersion: v1
clusters:
- cluster:
    server: ${endpoint}
    certificate-authority-data: ${cluster_auth_base64}
  name: ${kubeconfig_name}
contexts:
- context:
    cluster: ${kubeconfig_name}
    user: ${kubeconfig_name}
  name: ${kubeconfig_name}
current-context: ${kubeconfig_name}
kind: Config
preferences: {}
users:
- name: ${kubeconfig_name}
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1alpha1
      args:
      - --region
      - us-east-2
      - eks
      - get-token
      - --cluster-name
      - ${clustername}
      command: aws
      env:
      - name: AWS_PROFILE
        value: ${environment}
