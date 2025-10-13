#!/usr/bin/env bash

set -eo pipefail

# Consider dmenuing for options like video size?
ffplay -video_size 640x480 /dev/video0
