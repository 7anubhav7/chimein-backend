#!/usr/bin/env bash

cd /home/ec2-user/chimein-backend
sudo rm -rf env-file.zip
sudo rm -rf .env
sudo rm -rf .env.staging
aws s3 sync s3://chimein-bucket/backend/staging .
unzip env-file.zip
sudo cp .env.staging .env
sudo npm run delete
sudo npm install
