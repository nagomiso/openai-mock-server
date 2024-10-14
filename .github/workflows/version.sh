#!/bin/bash -me
new_version_tag_prefix() {
  date +'v%Y.%m.%d'
}

tag_exists() {
  git fetch --tags > /dev/null 2>&1
  git rev-parse --verify "$1" > /dev/null 2>&1
}

new_version_tag() {
  prefix=$(new_version_tag_prefix)
  if ! tag_exists "${prefix}"; then
    echo "${prefix}"
    return 0
  fi
  suffix=1
  while true; do
    tag="${prefix}-${suffix}"
    if ! tag_exists "${tag}"; then
      echo "${tag}"
      return 0
    fi
    suffix=$((suffix+1))
  done
}

new_version_tag
