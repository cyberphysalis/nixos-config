#!/bin/env bash

export version=1.0.72
nix hash convert --hash-algo sha256 \
$(nix-prefetch-url  https://registry.npmjs.org/@musistudio/claude-code-router/-/claude-code-router-${version}.tgz)

cd $(mktemp -d)
git clone https://github.com/musistudio/claude-code-router.git && \
  cd claude-code-router && \
  nix-shell -p nodejs_20 --run "npm install --package-lock-only" && \
  cp -vf package-lock.json ~/nixos/overlays/claude-code-router/

cd -
# modify hash and version in default.nix
nix develop ./#claude-code-router
