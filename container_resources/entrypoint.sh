#!/bin/bash
set -e

BIND_DATA_DIR=${DATA_DIR}/bind

create_bind_data_dir() {
  mkdir -p ${BIND_DATA_DIR}

  # populate default bind configuration if it does not exist
  if [ ! -d ${BIND_DATA_DIR}/etc ]; then
    mv /etc/bind ${BIND_DATA_DIR}/etc
  fi
  rm -rf /etc/bind
  ln -sf ${BIND_DATA_DIR}/etc /etc/bind
  chmod -R 0775 ${BIND_DATA_DIR}
  chown -R ${BIND_USER}:${BIND_USER} ${BIND_DATA_DIR}
}

create_pid_dir() {
  mkdir -p /var/run/bind
  chmod 0775 /var/run/bind
  chown root:${BIND_USER} /var/run/bind
}

create_bind_cache_dir() {
  mkdir -p /var/cache/bind
  chmod 0775 /var/cache/bind
  chown root:${BIND_USER} /var/cache/bind
}

create_alias_create_key(){
  rm -rf /bin/create-key
  ln -s /opt/create-key.sh /bin/create-key
}

create_pid_dir
create_bind_data_dir
create_bind_cache_dir
create_alias_create_key

# allow arguments to be passed to bind
if [[ ${1:0:1} = '-' ]]; then
  EXTRA_ARGS="$*"
  set --
elif [[ ${1} == bind || ${1} == "$(command -v bind)" ]]; then
  EXTRA_ARGS="${*:2}"
  set --
fi

# default behaviour is to launch bind
if [[ -z ${1} ]]; then
  echo "Starting bind..."
  exec $(which named) -u ${BIND_USER} -g ${EXTRA_ARGS}
else
  exec "$@"
fi
