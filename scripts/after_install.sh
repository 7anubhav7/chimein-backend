#!/usr/bin/env bash

cd /home/ec2-user/chimein-backend
sudo rm -rf env-file.zip
sudo rm -rf .env
sudo rm -rf .env.production
aws s3 sync s3://chimein-bucket/backend/production .
unzip env-file.zip
sudo cp .env.production .env
sudo npm run delete
sudo npm install
