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

log_banner "pretalx Server Dev Setup"

log_info "Installing pretalx development package..."
if python3 -m pip install --upgrade-strategy eager "pretalx[dev]"; then
    log_success "pretalx installed successfully."
else
    log_error "pretalx installation failed!"
    exit 1
fi

log_info "Applying database migrations..."
if python3 -m pretalx migrate; then
    log_success "Migrations applied successfully."
else
    log_error "Migration failed!"
    exit 1
fi

log_setup_complete
