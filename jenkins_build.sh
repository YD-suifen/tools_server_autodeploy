#!/bin/bash


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
        git_repo="/var/lib/jenkins/workspace/kl-agent-server/kl-agent-backend"
        cd $git_repo
        /usr/bin/git checkout $branch && /usr/bin/git pull
        /usr/bin/yarn install
        /usr/local/bin/npm run build
        /usr/bin/tar -czf $i.tar.gz dist

      elif [ $i == "frontend" ]; then  
        git_repo="/var/lib/jenkins/workspace/kl-agent-server/kl-agent-frontend"
        cd $git_repo
        /usr/bin/git checkout $branch && /usr/bin/git pull
        /usr/bin/yarn install
        /usr/local/bin/npm run build
        /usr/bin/tar -czf $i.tar.gz dist
      else
        echo "input string is error"
        exit 1
      fi

    done
  else
    cd $git_repo
    /usr/bin/git checkout $branch && /usr/bin/git pull

    /usr/bin/yarn install
    /usr/local/bin/npm run build
    /usr/bin/tar -czf $project.tar.gz dist
  fi 
}


action