docker stop docker-livy
docker container rm docker-livy
docker run -dit -p 8998:8998 --name docker-livy  wkflow/livy:v1

