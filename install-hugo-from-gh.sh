#!/usr/bin/env bash
set -euo pipefail

readonly BINARY_NAME="hugo"
readonly DOWNLOAD_BASE_URL="https://github.com/gohugoio/hugo/releases/download"

readonly TMP_DOWNLOAD_DIR="$(mktemp -d)"
trap 'rm -rf "${TMP_DOWNLOAD_DIR?}"' EXIT

error_exit() {
  echo "$1" >&2
  exit "${2:-1}"
}

platform() {
  case "$(uname)" in
    Darwin)
      echo "macOS-64bit"
      ;;
    Linux)
      echo "Linux-64bit"
      ;;
  esac
}

install() {
  local -r install_version="$1"
  local -r install_path="$2"
  local -r base_version="${install_version}"
  local -r full_version=extended_"${install_version}"
  local -r install_path_bin="${install_path}/bin"
  local -r download_url="${DOWNLOAD_BASE_URL}/v${base_version}/${BINARY_NAME}_${full_version}_$(platform).tar.gz"
  local -r download_path="${TMP_DOWNLOAD_DIR}/${BINARY_NAME}.tar.gz"
  local -r extracted_path="${TMP_DOWNLOAD_DIR}/extracted"

  echo "Downloading from ${download_url}"
  if curl -fL -o "$download_path" "$download_url"; then
    echo "Installing"
    mkdir "$extracted_path"
    tar -xzf "$download_path" -C "$extracted_path"
    mkdir -p "$install_path_bin"
    mv "${extracted_path}/hugo" "$install_path_bin"
  else
    error_exit "Error: ${BINARY_NAME} version ${install_version} not found"
  fi
}

install "$HUGO_VERSION" "$HUGO_PATH"


