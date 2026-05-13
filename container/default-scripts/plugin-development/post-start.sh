#!/bin/sh
# Default post-start.sh script for pretalx plugin development.
# Overview:
#   1. Ensure pretalx configuration file exists (copy from template if needed).
#
# LICENSE_MARKER

SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
# shellcheck source=../lib/common.sh
. "$SCRIPT_DIR/../lib/common.sh"

# Configuration file paths
CFG_FILE="${PRETALX_DEVCONTAINER_CFG_FILE:-./.devcontainer/pretalx.cfg}"
TEMPLATE_FILE="${PRETALX_DEVCONTAINER_TEMPLATE_FILE:-./.devcontainer/pretalx.cfg.template}"

# Help banner
print_help() {
    printf "${BLUE_BOLD}===========================\n"
    printf " pretalx Plugin Dev Setup  \n"
    printf "===========================${NC}\n"
    printf "\n";
    printf "Usage:\n";
    printf "  %s [OPTIONS]\n" "$0";
    printf "\n";
    printf "Options:\n";
    printf "  -h, --help              Show this help message and exit.\n";
    printf "\n";
}

# Parse CLI flags
for arg in "$@"; do
    case "$arg" in
        -h|--help)
            print_help
            exit 0
            ;;
        *)
            log_unknown_argument_and_exit "$arg"
            ;;
    esac
done

log_banner "pretalx Plugin Dev Setup"

# Ensure configuration file exists
if [ -f "$CFG_FILE" ]; then
    printf "${GREEN}Configuration file already exists: %s${NC}\n" "$CFG_FILE";
else
    if [ -f "$TEMPLATE_FILE" ]; then
        log_info "Creating configuration file from template..."
        cp "$TEMPLATE_FILE" "$CFG_FILE"
        printf "${GREEN}Configuration file created: %s${NC}\n" "$CFG_FILE";
    else
        printf "${RED}Template file not found: %s${NC}\n" "$TEMPLATE_FILE"
        exit 1;
    fi
fi

log_setup_complete
exit 0;
