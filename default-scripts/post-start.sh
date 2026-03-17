#!/bin/sh
# Default post-start.sh script for pretalx server development.
# Overview:
#   1. Currently it does nothing.
#
# LICENSE_MARKER

SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
# shellcheck source=./lib/common.sh
. "$SCRIPT_DIR/lib/common.sh"

log_banner "pretalx Server Dev Setup"
log_info "Nothing to do"
log_setup_complete
exit 0;
