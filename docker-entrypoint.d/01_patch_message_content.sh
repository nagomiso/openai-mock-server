#!/bin/bash -me
yq eval -i \
    '.components.schemas.ChatCompletionResponseMessage.properties.content.example = "Hello World!!"' \
    /app/openapi.yaml
