#!/bin/sh
# Default post-create.sh script for pretalx plugin development.
# Overview:
#   1. Installing pretalx
#   2. Installing the plugin.
#   3. Apply database migrations.
#
# LICENSE_MARKER

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW_BOLD='\033[1;33m'
BLUE_BOLD='\033[1;34m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Banner
printf "${BLUE_BOLD}==========================\n"
printf " pretalx Plugin Dev Setup \n"
printf "==========================\n"
printf "${BLUE}Script: $0 ${NC}\n"

# Install pretalx
printf "${YELLOW_BOLD}==> Installing pretalx development package...${NC}\n";
if python -m pip3 install --upgrade-strategy eager "pretalx[dev]"; then
    printf "${GREEN}pretalx installed successfully.${NC}\n";
else
    printf "${RED}pretalx installation failed!${NC}\n";
    exit 1
fi

# Install local plugin
printf "${YELLOW_BOLD}==> Installing local plugin in editable mode...${NC}\n"
if python -m pip install -e .; then
    printf "${GREEN}Plugin installed successfully.${NC}\n"
else
    printf "${RED}Plugin installation failed!${NC}\n"
    exit 1
fi

# Apply migrations
printf "${YELLOW_BOLD}==> Applying database migrations...${NC}\n"
if python3 -m pretalx migrate; then
    printf "${GREEN}Migrations applied successfully.${NC}\n"
else
    printf "${RED}Migration failed!${NC}\n"
    exit 1
fi

printf "${BLUE_BOLD}Setup complete. Happy coding!${NC}\n"