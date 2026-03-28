#!/usr/bin/env bash

# SPDX-License-Identifier: MIT
# Copyright (c) 2026 Ramil Safin

set -euo pipefail

# Build Docker images using buildx bake and load to local daemon

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

DEFAULT_TARGET="torch-py312-torch211-cu130"
DEFAULT_VERBOSE=false

TARGET="${DEFAULT_TARGET}"
VERBOSE="${DEFAULT_VERBOSE}"
BAKE_FILE="docker-bake.hcl"

print_info() {
  echo -e "${GREEN}[INFO]${NC} $1"
}

print_error() {
  echo -e "${RED}[ERROR]${NC} $1" >&2
}

show_usage() {
  cat << EOF
Usage: $0 [OPTIONS]

Build Docker images with buildx bake and load to local daemon.

OPTIONS:
  -t, --target TARGET          Build target (default: ${DEFAULT_TARGET})
  -f, --file FILE              Bake file path (default: ${BAKE_FILE})
  -v, --verbose                Enable verbose output
  -h, --help                   Show this help message

EXAMPLES:
  # Build default target and load to daemon
  $0

  # Build specific target
  $0 --target torch-py310-torch25-cu118

  # Build with verbose output
  $0 --target torch-py310-torch25-cu118 --verbose
EOF
    exit 0
}

while [[ $# -gt 0 ]]; do
  case $1 in
    -t|--target)
      TARGET="$2"
      shift 2
      ;;
    -f|--file)
      BAKE_FILE="$2"
      shift 2
      ;;
    -v|--verbose)
      VERBOSE=true
      shift
      ;;
    -h|--help)
      show_usage
      ;;
    *)
      print_error "Unknown option: $1"
      show_usage
      ;;
  esac
done

if [[ ! -f "$BAKE_FILE" ]]; then
  print_error "Bake file not found: $BAKE_FILE"
  exit 1
fi

if ! command -v docker &> /dev/null; then
  print_error "Docker is not installed or not in PATH"
  exit 1
fi

if ! docker buildx version &> /dev/null; then
  print_error "Docker buildx is not available"
  exit 1
fi

BUILD_CMD="docker buildx bake"
BUILD_CMD="$BUILD_CMD -f $BAKE_FILE"
BUILD_CMD="$BUILD_CMD $TARGET"
BUILD_CMD="$BUILD_CMD --load"

if [[ "$VERBOSE" == true ]]; then
  BUILD_CMD="$BUILD_CMD --progress=plain"
else
  BUILD_CMD="$BUILD_CMD --progress=auto"
fi

print_info "Executing build command:"
echo "  $BUILD_CMD"
echo ""

print_info "Starting build..."
if eval "$BUILD_CMD"; then
  print_info "Build completed successfully and loaded to Docker daemon!"
else
  print_error "Build failed!"
  exit 1
fi