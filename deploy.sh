docker build -t gustavoarmelin/multi-client:latest -t gustavoarmelin/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t gustavoarmelin/multi-server:latest -t gustavoarmelin/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t gustavoarmelin/multi-worker:latest -t gustavoarmelin/multi-worker:$SHA -f ./worker/Dockerfile ./worker

# push images to docker hub
docker push gustavoarmelin/multi-client:latest
docker push gustavoarmelin/multi-server:latest
docker push gustavoarmelin/multi-worker:latest

docker push gustavoarmelin/multi-client:$SHA
docker push gustavoarmelin/multi-server:$SHA
docker push gustavoarmelin/multi-worker:$SHA

# apply k8s images
kubectl apply -f k8s
kubectl set image deployments/server-deployment server=gustavoarmelin/multi-server:$SHA
kubectl set image deployments/client-deployment client=gustavoarmelin/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=gustavoarmelin/multi-worker:$SHA
