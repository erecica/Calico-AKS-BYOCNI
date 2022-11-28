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

Get RESOURCE performence info 

```
kubectl top <RESOURCE>
```


Get deployments

```
kubectl get deployments -A
```
>Add -w to watch (tail) the view

Get deployments | matching STRING

```
kubectl get deployments -A | egrep <STRING> 
```



Scale deployment

```
kubectl scale --replicas=n deployments/<NAME> -n <NAMESPACE>
```