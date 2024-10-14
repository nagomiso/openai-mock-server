# OpenAI mock server image

This repository contains image definitions for using a simple mock OpenAI API server.

## Overview

This project leverages the OpenAPI schema from [openai/openai-openapi](https://github.com/openai/openai-openapi) and utilizes [stoplightio/prism](https://github.com/stoplightio/prism) to create a simple mock server for OpenAI's API. As a simple mock server, it does not support advanced mocking capabilities.

## Usage

```bash
❯ docker pull ghcr.io/nagomiso/openai-mock-server:nightly
❯ docker run -it --rm -p 4010:4010 ghcr.io/nagomiso/openai-mock-server:nightly
```

If there are any processes you want to run before startup,
please mount a shell script in `/docker-entrypoint.d`.

[`./docker-entrypoint.d/01_patch_message_content.sh`](./docker-entrypoint.d/01_patch_message_content.sh)
is an example of a script that patches the response content of the `POST /chat/completions` endpoint.

```bash
❯ docker run -it --rm -p 4010:4010 \
    -v $(pwd)/docker-entrypoint.d:/docker-entrypoint.d \
    ghcr.io/nagomiso/openai-mock-server:nightly
❯ curl -X POST \
  --url http://localhost:4010/chat/completions \
  --header 'Authorization: Bearer xxxxxx' \
  --header 'Content-Type: application/json' \
  --data '{
  "model": "gpt-4o-mini",
  "messages": [
    {
      "role": "user",
      "content": "Hello!!"
    }
  ]
}'
{"id":"string","choices":[{"finish_reason":"stop","index":0,"message":{"content":"Hello World!!","refusal":"string","tool_calls":[{"id":"string","type":"function","function":{"name":"string","arguments":"string"}}],"role":"assistant","function_call":{"arguments":"string","name":"string"}},"logprobs":{"content":[{"token":"string","logprob":0,"bytes":[0],"top_logprobs":[{"token":"string","logprob":0,"bytes":[0]}]}],"refusal":[{"token":"string","logprob":0,"bytes":[0],"top_logprobs":[{"token":"string","logprob":0,"bytes":[0]}]}]}}],"created":0,"model":"string","service_tier":"scale","system_fingerprint":"string","object":"chat.completion","usage":{"completion_tokens":0,"prompt_tokens":0,"total_tokens":0,"completion_tokens_details":{"reasoning_tokens":0}}}%
```

## Image tags

- `vYYYY.mm.dd-{openai-openapi commit hash}`: The image is released.
- `latest`: The image is latest released.
