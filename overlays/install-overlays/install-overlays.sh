#!/usr/bin/env bash

OVERLAYS_DIR="$HOME/nixos/overlays"
INSTALL_DIR="${PWD}/.flake"

echo "overlays dir: ${OVERLAYS_DIR}"
echo "install overlay to: ${INSTALL_DIR}"

TARGET_OVERLAY_DIR_PATH="${OVERLAYS_DIR}/${1}"
if [[ -d "${TARGET_OVERLAY_DIR_PATH}" ]];then
  mkdir -p ${INSTALL_DIR}
  cp -rf ${TARGET_OVERLAY_DIR_PATH} "${INSTALL_DIR}/"
  echo "install success! use by \'(import .flake/${1})\'"
  exit 0;
fi

TARGET_OVERLAY_FILE_PATH="${OVERLAYS_DIR}/${1}.nix"
if [[ -f "${TARGET_OVERLAY_FILE_PATH}" ]];then
  mkdir -p ${INSTALL_DIR}
  cp -rf ${TARGET_OVERLAY_FILE_PATH} "${INSTALL_DIR}/"
  echo "install success! use by \'(import .flake/${1})\'"
  exit 0;
fi

echo "install failed! neither ${TARGET_OVERLAY_DIR_PATH} or ${TARGET_OVERLAY_FILE_PATH} exists."
exit 1
