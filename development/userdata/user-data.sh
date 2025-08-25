#!/usr/bin/env bash
function program_is_installed {
  local return_=1

  type $1 >/dev/null 2>&1 || { local return_=0; }
  echo "$return_"
}

sudo dnf update -y

if [ $(program_is_installed node) == 0 ]; then
  curl -fsSL https://rpm.nodesource.com/setup_22.x | sudo bash -
  sudo dnf install -y nodejs
fi

if [ $(program_is_installed pm2) == 0 ]; then
  sudo npm install -g pm2
fi

if [ $(program_is_installed git) == 0 ]; then
  sudo dnf install git -y
fi

if [ $(program_is_installed zip) == 0 ]; then
  sudo dnf install zip -y
fi

cd /home/ec2-user

git clone -b develop https://github.com/7anubhav7/chimein-backend.git

cd chimein-backend
npm install
aws s3 sync s3://chimein-bucket/develop .
unzip env-file.zip
cp .env.develop .env
npm run build
npm run start
