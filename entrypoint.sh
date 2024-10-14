#!/bin/bash -me
cp -a /app/openapi.yaml /tmp/openapi.yaml
if [ -d "/docker-entrypoint.d/" ]; then
  find "/docker-entrypoint.d/" -follow -type f -print | sort -V | while read -r f; do
    case "${f}" in
      *.envsh)
          if [ -x "${f}" ]; then
              echo "Source ${f}"
              . "${f}"
          else
            :
          fi
          ;;
      *.sh)
          if [ -x "${f}" ]; then
              echo "Run ${f}"
              "${f}"
          else
            :
          fi
          ;;
      *) ;;
    esac
  done
fi

/usr/local/bin/nodejs "$@"
