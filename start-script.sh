az group create --name Calico-AKS-Resourcegroup --location  westeurope && \
az aks create --resource-group Calico-AKS-Resourcegroup --name Calico-AKS-Workshop --location westeurope --pod-cidr 192.168.0.0/16 --network-plugin none --generate-ssh-keys && \
az aks get-credentials --resource-group Calico-AKS-Resourcegroup --name Calico-AKS-Workshop && \
kubectl create -f ./tigera-operator.yaml && \
kubectl create -f ./tigera-operator-installation.yaml && \
kubectl apply -f ./yaobank-org.yaml && \
kubectl apply -f ./yoabank-loadbalancer.yaml && \
kubectl get svc -n yaobank-customer yaobank-customer -w