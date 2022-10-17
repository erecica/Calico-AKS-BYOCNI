az aks delete --name Calico-AKS-Workshop --resource-group Calico-AKS-Resourcegroup --debug -y && \
az group delete --resource-group Calico-AKS-Resourcegroup --debug -y && \
kubectl config delete-cluster Calico-AKS-Workshop && \
kubectl config delete-context Calico-AKS-Workshop && \
kubectl config delete-user clusterUser_Calico-AKS-Resourcegroup_Calico-AKS-Workshop && \
clouddrive unmount
