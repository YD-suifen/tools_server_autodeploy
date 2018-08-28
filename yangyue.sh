#!/bin/bash


cd /var/lib/jenkins/workspace/kl-agent-backend

/usr/bin/yarn install

git checkout master
git pull
npm run build

tar -czvf backend.tar.gz dist




#!/bin/bash

/mnt/website/agent-management

scp root@172.16.204.246:/var/lib/jenkins/workspace/kl-agent-backend/backend.tar.gz .
tar -xvf backend.tar.gz backend && cd backend.tar.gz

tar -xzvf backend.tar.gz backend && mv dist backend

sed 's/test/jining/g' config.json


pm2 stop kl-agent-backend



cd /mnt/website/kl-agent-management/backend/

NODE_ENV=production pm2 start server.js -o out.log -e err.log --name kl-agent-backend