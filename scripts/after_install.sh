#!/usr/bin/env bash

cd /home/ec2-user/chimein-backend
sudo rm -rf env-file.zip
sudo rm -rf .env
sudo rm -rf .env.develop
aws s3 sync s3://chimein-bucket/backend/develop .
unzip env-file.zip
sudo cp .env.develop .env
sudo npm run delete
sudo npm install
