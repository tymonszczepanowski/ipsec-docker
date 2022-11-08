#!/bin/env bash

if command -v docker &> /dev/null; then
  echo "[image] Found docker, begin creating image."
  docker  build -t ipsec-alpine:latest .
fi
