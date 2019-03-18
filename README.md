# Rancher Container Exec

This small project allows you to easily execute a command into a Rancher Container.

## Usage 

### With the container-exec.sh script

Requirements : `curl, jq, wsta`.

Usage : 

```bash
$ ./container-exec.sh \ 
    --rancher-public=YOUR_RANCHER_PUBLIC_KEY \
    --rancher-secret=YOUR_RANCHER_SECRETT_KEY \ 
    --rancher-host=https://YOUR_RANCHER_HOST \
    --rancher-websocket=wss://YOUR_RANCHER_HOST/v1/exec \
    --container-name=_YOUR_CONTAINER_NAME \
    --command='"your", "commands"'
```

### With the Docker image

```
docker run acseo/rancher-container-exec  \
    --rancher-public=YOUR_RANCHER_PUBLIC_KEY \
    --rancher-secret=YOUR_RANCHER_SECRETT_KEY \ 
    --rancher-host=https://YOUR_RANCHER_HOST \
    --rancher-websocket=wss://YOUR_RANCHER_HOST/v1/exec \
    --container-name=_YOUR_CONTAINER_NAME \
    --command='"your", "commands"'
```
