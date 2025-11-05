#!/usr/bin/env bash

cd /home/ec2-user/chimein-backend
npm run build
npm run stop
npm run delete

# Start app in cluster mode and exit immediately
NODE_ENV=production pm2 start ./build/src/app.js -i 5 --name chimein --output ./logs/out.log --error ./logs/error.log

# Save PM2 state
pm2 save

exit 0
