
docker build -t wkflow/livy:v1 .

docker tag wkflow/livy:v1  us.icr.io/aaronfand/docker-livy:v1 
ibmcloud cr login
docker push us.icr.io/aaronfand/docker-livy:v1 
