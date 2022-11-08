#!/bin/env bash

if command -v docker &> /dev/null; then
  echo "[image] Found docker, begin removing image."
  docker rmi -f ipsec-alpine:latest
fi
