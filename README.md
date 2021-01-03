## Instructions

```
minikube start                                                         # Start Minikube
git clone git@github.com:hongjinn/demo-kubernetes-django-nginx.git     # Clone this repository
cd manifests                                                           # Go to the manifests folder
kubectl apply -f secret.yaml                                           # Create the environmental variables for Djanog, SECRET_KEY and DEBUG
kubectl apply -f deploy-src.yaml                                       # Create the django-gunicorn pod
kubectl apply -f svc-src.yaml                                          # Create a LoadBalancer service to see the test site
```
