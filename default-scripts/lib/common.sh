#!/bin/sh
# Shared helpers for devcontainer setup scripts.

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW_BOLD='\033[1;33m'
BLUE_BOLD='\033[1;34m'
BLUE='\033[0;34m'
NC='\033[0m'

log_banner() {
    title="$1"
    printf "${BLUE_BOLD}===========================\n"
    printf " %s\n" "$title"
    printf "===========================${NC}\n"
    printf "${BLUE}Script:             %s${NC}\n" "$0"
    printf "${BLUE}Current working directory: %s${NC}\n" "$(pwd)"
}

log_info() {
    printf "${YELLOW_BOLD}==> %s${NC}\n" "$1"
}

log_warning() {
    printf "${YELLOW_BOLD}Warning: %s${NC}\n" "$1"
}

log_success() {
    printf "${GREEN}%s${NC}\n" "$1"
}

log_error() {
    printf "${RED}%s${NC}\n" "$1"
}

log_setup_complete() {
    printf "${BLUE_BOLD}Setup complete. Happy coding!${NC}\n"
}

log_unknown_argument_and_exit() {
    argument="$1"
    log_error "Unknown argument: ${argument}"
    printf "Run '%s --help' for usage information.\n" "$0"
    exit 1
}