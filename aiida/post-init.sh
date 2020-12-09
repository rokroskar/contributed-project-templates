#!/bin/bash

# Overwrite user info
# Note: This can be removed once activate-aiida is updated
#https://github.com/chrisjsewell/activate_aiida/issues/6

# See https://stackoverflow.com/a/17841619/1069467
function join_by { local d=$1; shift; local f=$1; shift; printf %s "$f" "${@/#/$d}"; }
user=($GIT_AUTHOR_NAME)
first_name=${user[0]}
last_name=`join_by ' ' "${user[@]:1}"`

sed -i "s/aiida@localhost/'$EMAIL'/" aiida_config.yaml
sed -i "s/MaX/'$first_name'/" aiida_config.yaml
sed -i "s/Scientist/'$last_name'/" aiida_config.yaml


# Add AIIDA_PATH environment variable 
profile_file=~/.bashrc
if ! grep -q 'AIIDA_PATH' "${profile_file}" ; then
  echo "export AIIDA_PATH=\"/work/${CI_PROJECT}/repo\"" >> "${profile_file}"
fi

# create database, start daemon
source aiida-activate -c -w 1
