#!/usr/bin/env bash

cd /home/ec2-user/chimein-backend
npm run build
npm run stop
npm run delete

# Start app in cluster mode and exit immediately
npm run start

# Save PM2 state
pm2 save

exit 0
