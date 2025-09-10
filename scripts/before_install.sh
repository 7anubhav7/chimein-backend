#!/usr/bin/env bash

DIT="/home/ec2-user/chimein-backend"
if [ -d "$DIR" ]; then
  cd /home/ec2-user
  sudo rm -rf chimein-backend
else
  echo "Directory does not exist"
fi
