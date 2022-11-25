# Useful commands

Get config
```
kubectl config view
```

Get nodes
```
kubectl get nodes
```

Explain resource

```
kubectl explain <RESOURCE>
```
> Possible resource types include: pods (po), services (svc), replicationcontrollers (rc), nodes (no), events (ev), componentstatuses (cs), limitranges (limits), persistentvolumes (pv), persistentvolumeclaims (pvc), resourcequotas (quota), namespaces (ns), horizontalpodautoscalers (hpa) or endpoints (ep).

Get deployments

```
kubectl get deployments -A
```

Get deployments | matching STRING

```
kubectl get deployments -A | egrep <STRING> 
```