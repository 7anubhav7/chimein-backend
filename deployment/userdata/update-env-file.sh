#!/usr/bin/env bash
aws s3 sync s3://chimein-bucket/backend/develop .
unzip env-file.zip
cp .env.develop .env
rm .env.develop
sed -i -e "s|^ *REDIS_HOST=.*|REDIS_HOST=redis://$ELASTICACHE_ENDPOINT:6379|" .env
rm -rf env-file.zip
cp .env .env.develop
zip env-file.zip .env.develop
aws --region ap-south-1 s3 cp env-file.zip s3://chimein-bucket/backend/develop/
rm -rf .env*
rm -rf env-file.zip
