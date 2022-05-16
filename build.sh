#! /bin/bash

DOCKER_BUILDKIT=1 docker build -f Dockerfile --rm -t davboot01/xilinx_ise:14.7 .
