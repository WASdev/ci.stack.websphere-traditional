#!/bin/bash

# setup environment
. $( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/env.sh

# Check if can login to docker hub
if [ -n "$DOCKER_USERNAME" ] && [ -n "$DOCKER_PASSWORD" ]; then
    echo "performing docker login for pulls"
    echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" "docker.io" --password-stdin
    else
        echo "No DOCKER_USERNAME specified in settings"
fi

# Allow multiple stacks to be selected
if [ $# -gt 0 ]
then
  export STACKS_LIST="$@"
  echo "STACKS_LIST=$STACKS_LIST"

  for stack_name in $STACKS_LIST
  do
    if [ "${stack_name: -1}" == "/" ]
    then
      stack_name=${stack_name%?}
    fi
     
    stack_no_slash="$stack_no_slash $stack_name"
  done

  STACKS_LIST=$stack_no_slash
fi

if [ -z "$STACKS_LIST" ]
then
  . $script_dir/list.sh
fi

. $script_dir/package.sh
