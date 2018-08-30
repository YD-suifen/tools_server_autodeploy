#!/bin/bash

project_path="/mnt/website/kl-agent-management"
git_repo=

# rm -fr $project_path/back*
# scp -r root@172.16.204.246:$git_repo/backend.tar.gz $project_path/

# cd $project_path 
# if [ ! -f "backend.tar.gz" ]; then
#   echo "file download failed"
#   exit 1
# fi
# tar -xzf backend.tar.gz && mv dist backend

# #/mnt/website/kl-agent-management/backend/config/config.json
# cd $project_path/backend/config/
# sed -i 's/test/jining/g' config.json

# /usr/local/bin/pm2 stop kl-agent-backend

# cd $project_path/backend/

# NODE_ENV=production /usr/local/bin/pm2 start server.js -o out.log -e err.log --name kl-agent-backend


function frontenddev(){
  rm -fr $project_path/fronte*
  scp -r root@172.16.204.246:$git_repo/frontend.tar.gz $project_path/
  cd $project_path 
  if [ ! -f "frontend.tar.gz" ]; then
    echo "file download failed"
    exit 1
  fi
  tar -xzf frontend.tar.gz && mv dist frontend

  /usr/bin/systemctl restart nginx


}



function backenddev(){

  rm -fr $project_path/back*
  scp -r root@172.16.204.246:$git_repo/backend.tar.gz $project_path/

  cd $project_path 
  if [ ! -f "backend.tar.gz" ]; then
    echo "file download failed"
    exit 1
  fi
  tar -xzf backend.tar.gz && mv dist backend

  cd $project_path/backend/config/
  sed -i 's/test/jining/g' config.json

  /usr/local/bin/pm2 stop kl-agent-backend

  cd $project_path/backend/

  NODE_ENV=production /usr/local/bin/pm2 start server.js -o out.log -e err.log --name kl-agent-backend
  
}


project=
branch=
git_repo=
all=

while getopts ":p:b:h:a:" opt; do
  case $opt in
    p)
      echo "echo project : $OPTARG"
      if [ $OPTARG == "backend" ]; then
        project="backend"
        git_repo="/var/lib/jenkins/workspace/kl-agent-server/kl-agent-backend"
      elif [ $OPTARG == "frontend" ]; then
        project="frontend"
        git_repo="/var/lib/jenkins/workspace/kl-agent-server/kl-agent-frontend"
      else
        echo "input string is error"
        exit 1
      fi

      ;;
    b)
      echo "echo branch: $OPTARG"
      if [ $OPTARG == "master" ]; then
        branch="master"
      elif [ $OPTARG == "pomelo_client" ]; then
        branch="pomelo_client"
      else
        echo "input string is error"
        exit 1
      fi
      ;;
    h)
      echo "Invalid option: -$OPTARG"
      ;;
    a)
      if [ $OPTARG == "all" ]; then
        all="all"
      else
        echo "option a input error"
        exit 1
      fi

  esac
done


function action() {
  if [ $all == "all" ]; then
    projectlist=["backend","frontend"]
    for i in $projectlist
    do
      if [ $i == "backend" ]; then
        backenddev

      elif [ $i == "frontend" ]; then  
        frontenddev
      else
        echo "input string is error"
        exit 1
      fi

    done
  elif [ $project == "backend" ]; then
    backenddev
  elif [ $project == "frontend" ]; then
    frontenddev
  fi    
}


action