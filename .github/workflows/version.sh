#!/bin/bash -me
new_version_tag_prefix() {
  date +'v%Y.%m.%d'
}

tag_exists() {
  git fetch --tags > /dev/null 2>&1
  git rev-parse --verify "$1" > /dev/null 2>&1
}

openai_openapi_revision() {
  git submodule status openai-openapi | awk '{print $1}' | cut -c 1-7
}

new_version_tag() {
  prefix="$(new_version_tag_prefix)"
  revision="$(openai_openapi_revision)"
  tags="${prefix}-${revision}"
  if ! tag_exists "${tags}"; then
    echo "${tags}"
    return 0
  fi
  suffix=1
  while true; do
    tag="${prefix}-${suffix}-${revision}"
    if ! tag_exists "${tag}"; then
      echo "${tag}"
      return 0
    fi
    suffix=$((suffix+1))
  done
}

new_version_tag
