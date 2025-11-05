#!/usr/bin/env bash
aws s3 sync s3://chimein-bucket/backend/production .
unzip env-file.zip
cp .env.production .env
rm .env.production
sed -i -e "s|^ *REDIS_HOST=.*|REDIS_HOST=redis://$ELASTICACHE_ENDPOINT:6379|" .env
rm -rf env-file.zip
cp .env .env.production
zip env-file.zip .env.production
aws --region ap-south-1 s3 cp env-file.zip s3://chimein-bucket/backend/production/
rm -rf .env*
rm -rf env-file.zip
