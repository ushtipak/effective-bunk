#!/bin/bash
#
# Remove docker images in order to delete orphan layers

set +e

max_retries=5

# failsafe break if some images can't be removed after max_retries
retry=0
until [[ ${retry} -eq ${max_retries} ]]; do
  # remove all images with all tags
  docker images | tail -n+2 | awk '{print $1":"$2}' | xargs docker rmi

  # halt if all images have been removed
  [[ $(docker images -qa | wc -l) == 0 ]] && break

  ((retry++))
done

exit
