# Calico-AKS-BYOCNI
 Install Calico on AKS cluster with Bring Your Own CNI 

## Create resources commands

### 1. Create a resource group for this workshop
```az group create --name Calico-AKS-Resourcegroup --location  westeurope```

### 2. Create AKS cluster with no Kubernetes CNI pre-installed

```az aks create --resource-group Calico-AKS-Resourcegroup --name Calico-AKS-Workshop --location westeurope --pod-cidr 192.168.0.0/16 --network-plugin none --generate-ssh-keys```
> Note: It might take about 6-9 min 

### 3. Get credentials to allow you to access the cluster with kubectl

```az aks get-credentials --resource-group Calico-AKS-Resourcegroup --name Calico-AKS-Workshop```

### 4. Install the operator

```kubectl create -f ./tigera-operator.yaml```

### 5. Configure the Calico installation

```kubectl create -f ./tigera-operator-installation.yaml```

### 6. Deploying YAOBank 

```kubectl apply -f ./yaobank-org.yaml```

### 7. Verify our deployment

```kubectl get deployments -A | egrep yao```

### 8. Deploying a Load Balancer

```kubectl apply -f ./yoabank-loadbalancer.yaml```

### 9. Verify the service deployment

```kubectl get svc -n yaobank-customer yaobank-customer```

> Note: It might take 1-2 minutes for the loadbalancer service to acquire an external IP address

##  Clean up

### 1. Removing the AKS Cluster

```az aks delete --name Calico-AKS-Workshop --resource-group Calico-AKS-Resourcegroup -y ```
> Note: It might take 3-6 minutes to delete the cluster


### 2. Removing the Azure Resource Group

```az group delete --resource-group Calico-AKS-Resourcegroup -y```

### 3. Removing the AKS Kubeconfig Entries

```
kubectl config delete-cluster Calico-AKS-Workshop
kubectl config delete-context Calico-AKS-Workshop
kubectl config delete-user clusterUser_Calico-AKS-Resourcegroup_Calico-AKS-Workshop

```

### 4. Deleting the Cloud Shell Instance

```clouddrive unmount```
> You will be prompted to confirm twice.

>WARN: Removing a file share from Cloud Shell will terminate your current session.
Do you want to continue(y/n): y

> WARN: You will be prompted to create and mount a new file share on your next session.
Do you want to continue(y/n): y