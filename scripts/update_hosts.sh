#!/bin/bash

HOSTS=/etc/hosts

if [ -z "$1" ]; then
    echo ERROR: You must specify an argument. Example : symfony;
    exit 1;
fi

containerName=$1
hostName=$1.docker.dev

function removehost() {
  if [[ -n "$(grep $hostName /etc/hosts)" ]]
    then
      echo "$hostName Found in your $HOSTS, Removing now...";
      sudo sed -i".bak" "/$hostName/d" ${HOSTS}
    else
      echo "$hostName was not found in your $HOSTS";
  fi
}

function addhost() {
  HOSTS_LINE="$IP\t$hostName"
  if [[ -n "$(grep $hostName /etc/hosts)" ]]
    then
      removehost
  fi

  echo "Adding $hostName to your $HOSTS";
  sudo -- sh -c -e "echo '$HOSTS_LINE' >> /etc/hosts";

  if [[ -n "$(grep $hostName /etc/hosts)" ]]
    then
      echo "$hostName was added succesfully \n $(grep $hostName /etc/hosts)";
    else
      echo "Failed to Add $hostName, Try again!";
  fi
}

IP=`docker inspect -f '{{.Name}} - {{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $(docker ps -aq) | \
grep nginx_$containerName | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b"`

removehost
addhost