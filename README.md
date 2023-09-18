# Microshift on AWS via Terraform

Deploy Microshift to Amazon Web Services (AWS) via Terraform

# To Use

- (Optional) Copy/rename `terraform.tfvars.example` to `terraform.tfvars` and fill in the information (otherwise these will be prompted on apply):

  ```bash
  mv terraform.tfvars.example terraform.tfvars
  ```

- Initialize and apply the Terraform configuration. Provide verification to deploy Microshift (add `-auto-approve` to apply without user verification):

  ```bash
  terraform init && terraform apply
  ```

- The Terraform output provides access credentials for the cluster. 
  (NOTE: You can administer the cluster directly by SSH-ing to the microshift cluster, where `oc` is already configured and logged in with the default Cluster Administrator, `system:admin`):

  - To see all output:
    ```bash
    terraform output
    ```

  - To see only one output (handy for copy/paste or scripts):
    ```bash
    terraform output <variable>
    ```

- To access the clusters
  
  first get the content of kubeconfig
  ```bash
    terraform output kubeconfig_file
  ```
  and then execute the commands to get the kubeconfig content

  ```
  hchenxa@huichen-mac microshift_tf % ssh -i ~/.ssh/id_rsa ec2-user@18.191.135.1 sudo cat /var/lib/microshift/resources/kubeadmin/hchen-microshift1.dev09.red-chesterfield.com/kubeconfig > ./kubeconfig
  hchenxa@huichen-mac microshift_tf % KUBECONFIG=./kubeconfig oc get nodes
  NAME                                           STATUS   ROLES                         AGE   VERSION
  hchen-microshift1.dev09.red-chesterfield.com   Ready    control-plane,master,worker   20m   v1.26.4
  ```

- To destroy the cluster and its resources:
  ```bash
  terraform destroy
  ```