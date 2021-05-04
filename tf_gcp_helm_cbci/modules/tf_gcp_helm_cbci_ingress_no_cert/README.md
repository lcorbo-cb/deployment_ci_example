gcloud container clusters get-credentials --internal-ip example-private-cluster --region us-central1 --project lcorbo-sandbox-d79dc401
kubectl create namespace nginx-ingress
kubectl label  namespace nginx-ingress name=nginx-ingress
kubectl create namespace cloudbees-core
kubectl label namespace cloudbees-core name=cloudbees-core
export CERTIFICATE=../../sh_secrets_ps/certs/cbci/cbci.pem
export KEY=../../sh_secrets_ps/certs/cbci/cbci-key.pem
kubectl create secret tls ingress-cert-secret --cert ${CERTIFICATE} --key ${KEY} -n cloudbees-core
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
helm install nginx-ingress ingress-nginx/ingress-nginx \
  --values values/nginx.yaml \
  --set controller.nodeSelector."kubernetes\.io/os"="linux" \
  --namespace cloudbees-core \
  --version 2.15.0
kubectl config set-context $(kubectl config current-context) --namespace=cloudbees-core
sleep 160
CLOUDBEES_CORE_IP=$( \
  kubectl get service nginx-ingress-ingress-nginx-controller \
    --namespace=cloudbees-core \
    --output jsonpath="{.status.loadBalancer.ingress[0].ip}" \
)
DOMAIN_NAME="cbci.cloudbees.demo"
OLD_IP=$(nslookup -q=A $DOMAIN_NAME | tail -n+4 | sed -e '/^$/d' -e 's/Address://g' | grep -v 'Name|answer' | xargs -n1 | tail -1)
gcloud dns record-sets transaction start --zone cloudbees
gcloud dns record-sets list --zone cloudbees
gcloud dns record-sets transaction remove $OLD_IP --name="cbci.cloudbees.demo." --ttl="300" --type="A" --zone cloudbees
gcloud dns record-sets transaction add $CLOUDBEES_CORE_IP --name="cbci.cloudbees.demo." --ttl="300" --type="A" --zone cloudbees
gcloud dns record-sets transaction execute --zone cloudbees
gcloud dns record-sets list --zone cloudbees
helm repo add cloudbees https://charts.cloudbees.com/public/cloudbees
helm repo update
helm install cloudbees-core \
  --set OperationsCenter.HostName=$DOMAIN_NAME \
  --set OperationsCenter.Ingress.tls.Enable=true \
  --namespace cloudbees-core cloudbees/cloudbees-core \
  --values values/cloudbees.yaml
kubectl rollout status sts cjoc --namespace cloudbees-core
