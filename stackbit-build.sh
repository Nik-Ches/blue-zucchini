#!/usr/bin/env bash

set -e
set -o pipefail
set -v

curl -s -X POST https://api.stackbit.com/project/5e89bc4c9748d7001b1ce2cb/webhook/build/pull > /dev/null
if [[ -z "${STACKBIT_API_KEY}" ]]; then
    echo "WARNING: No STACKBIT_API_KEY environment variable set, skipping stackbit-pull"
else
    npx @stackbit/stackbit-pull --stackbit-pull-api-url=https://api.stackbit.com/pull/5e89bc4c9748d7001b1ce2cb 
fi
curl -s -X POST https://api.stackbit.com/project/5e89bc4c9748d7001b1ce2cb/webhook/build/ssgbuild > /dev/null
gatsby build
./inject-netlify-identity-widget.js public
curl -s -X POST https://api.stackbit.com/project/5e89bc4c9748d7001b1ce2cb/webhook/build/publish > /dev/null
