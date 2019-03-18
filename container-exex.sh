#!/bin/bash
#
# Author : Nicolas Potier / ACSEO
#

for i in "$@"
do
case $i in
    -rp=*|--rancher-public=*)
    RANCHER_PUBLIC="${i#*=}"
    shift # past argument=value
    ;;
    -rs=*|--rancher-secret=*)
    RANCHER_SECRET="${i#*=}"
    shift # past argument=value
    ;;
    -rh=*|--rancher-host=*)
    RANCHER_HOST="${i#*=}"
    shift # past argument=value
    ;;
    -rwsh=*|--rancher-websocket=*)
    RANCHER_WS="${i#*=}"
    shift # past argument=value
    ;;
    -c=*|--container-name=*)
    CONTAINER_NAME="${i#*=}"
    shift # past argument=value
    ;;
    -cmd=*|--command=*)
    COMMAND="${i#*=}"
    shift # past argument=value
    ;;
    --default)
    DEFAULT=YES
    shift # past argument with no value
    ;;
    *)
          # unknown option
    ;;
esac
done

if [ -z ${RANCHER_PUBLIC+1} ]; then echo "You must set the Rancher public key with the argument --rancher-public=VALUE"; exit -1; fi
if [ -z ${RANCHER_SECRET+1} ]; then echo "You must set the Rancher secret key with the argument --rancher-secret=VALUE"; exit -1; fi
if [ -z ${RANCHER_HOST+1} ]; then echo "You must set the Rancher secret key with the argument --rancher-host=VALUE"; exit -1; fi
if [ -z ${RANCHER_WS+1} ]; then echo "You must set the Rancher Websocket URL argument --rancher-websocket=VALUE"; exit -1; fi
if [ -z ${CONTAINER_NAME+1} ]; then echo "You must set the Rancher container name argument --container-name=VALUE"; exit -1; fi
if [ -z ${COMMAND+1} ]; then echo "You must set the Command to execute with the argument --commant=VALUE"; exit -1; fi

echo -e "Searching container $CONTAINER_NAME in $RANCHER_HOST"

STACK_ID=$(curl -u "$RANCHER_PUBLIC:$RANCHER_SECRET" -H 'Content-Type: application/json' -s "$RANCHER_HOST/v2-beta/containers?name=$CONTAINER_NAME" | jq '.data[0].accountId' | tr -d '"')

echo -e "Stack id is : $STACK_ID"

CONTAINER_ID=$(curl -u "$RANCHER_PUBLIC:$RANCHER_SECRET" -H 'Content-Type: application/json' -s "$RANCHER_HOST/v2-beta/containers?name=$CONTAINER_NAME" | jq '.data[0].id' | tr -d '"')

echo -e "Container id is : $CONTAINER_ID"

echo -e "Command to execute is : $COMMAND"

COMMAND_TOKEN=$(curl -u "$RANCHER_PUBLIC:$RANCHER_SECRET" -X POST -H "Content-Type: application/json" -d "{ \"attachStdin\": true, \"attachStdout\": true, \"command\": [$COMMAND], \"tty\": true }" -s "$RANCHER_HOST/v2-beta/projects/$STACK_ID/containers/$CONTAINER_ID?action=execute" | jq ".token" | tr -d '"')

echo -e "Command token is : $COMMAND_TOKEN"

wsta "$RANCHER_WS/?token=$COMMAND_TOKEN"
