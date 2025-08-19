#!/bin/env bash

export version=1.0.41
nix hash convert --hash-algo sha256 \
$(nix-prefetch-url  https://registry.npmjs.org/@musistudio/claude-code-router/-/claude-code-router-${version}.tgz)

cd $(mktemp -d)
git clone https://github.com/musistudio/claude-code-router.git && cd claude-code-router
npm install --package-lock-only
