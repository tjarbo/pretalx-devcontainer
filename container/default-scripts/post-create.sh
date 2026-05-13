#!/bin/sh
# Default post-create.sh script for pretalx server development.
# Overview:
#   1. Installing pretalx
#   2. Apply database migrations.
#
# LICENSE_MARKER

SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
# shellcheck source=./lib/common.sh
. "$SCRIPT_DIR/lib/common.sh"

log_banner "pretalx Development Post-Create Script"
log_info "Nothing to do"
log_setup_complete
