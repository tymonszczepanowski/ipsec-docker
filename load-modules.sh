#!/bin/env bash

# load needed modules, run with sudo
for module in af_key esp4 esp6; do modprobe $module;done

