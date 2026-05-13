#!/bin/sh
# Default post-create.sh script for pretalx server development.
# Overview:
#   1. Installing pretalx
#   2. Apply database migrations.
#   3. (Optional) Initialize pretalx.
#   4. (Optional) Collect static files.
#   5. (Optional) Create a dummy event.
#
# LICENSE_MARKER

SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
# shellcheck source=../lib/common.sh
. "$SCRIPT_DIR/../lib/common.sh"

# Help banner
print_help() {
    printf "${BLUE_BOLD}===========================\n"
    printf "  pretalx Server Dev Setup  \n"
    printf "===========================${NC}\n"
    printf "\n";
    printf "Usage:\n";
    printf "  %s [OPTIONS]\n" "$0";
    printf "\n";
    printf "Options:\n";
    printf "  --skip-pretalx-init     Skip the 'pretalx init' step.\n";
    printf "  --skip-dummy-event      Skip the dummy event creation step.\n";
    printf "  -h, --help              Show this help message and exit.\n";
    printf "\n";
    printf "Environment variables:\n";
    printf "  PRETALX_DEVCONTAINER_SKIP_INIT=1          Same as --skip-pretalx-init\n";
    printf "  PRETALX_DEVCONTAINER_SKIP_DUMMY_EVENT=1   Same as --skip-dummy-event\n";
    printf "\n";
}

# Default flag values (can be overridden by env vars)
SKIP_PRETALX_INIT="${PRETALX_DEVCONTAINER_SKIP_INIT:-0}"
SKIP_DUMMY_EVENT="${PRETALX_DEVCONTAINER_SKIP_DUMMY_EVENT:-0}"

# Configuration file paths
CFG_FILE="${PRETALX_DEVCONTAINER_CFG_FILE:-./.devcontainer/pretalx.cfg}"
TEMPLATE_FILE="${PRETALX_DEVCONTAINER_TEMPLATE_FILE:-./.devcontainer/pretalx.cfg.template}"

# These steps need non-empty values for all required init/superuser variables.
REQUIRED_INIT_ENV_VARS="DJANGO_SUPERUSER_EMAIL DJANGO_SUPERUSER_PASSWORD PRETALX_INIT_ORGANISER_NAME PRETALX_INIT_ORGANISER_SLUG"
MISSING_INIT_ENV_VARS=""
for env_var in $REQUIRED_INIT_ENV_VARS; do
    eval "env_value=\${$env_var:-}"
    if [ -z "$env_value" ]; then
        MISSING_INIT_ENV_VARS="$MISSING_INIT_ENV_VARS $env_var"
    fi
done

HAS_REQUIRED_INIT_ENV_VARS=1
if [ -n "$MISSING_INIT_ENV_VARS" ]; then
    HAS_REQUIRED_INIT_ENV_VARS=0
fi

# Parse CLI flags
for arg in "$@"; do
    case "$arg" in
        --skip-pretalx-init)
            SKIP_PRETALX_INIT=1
            ;;
        --skip-dummy-event)
            SKIP_DUMMY_EVENT=1
            ;;
        -h|--help)
            print_help
            exit 0
            ;;
        *)
            log_unknown_argument_and_exit "$arg"
            ;;
    esac
done

log_banner " pretalx Server Dev Setup  "
printf "${BLUE}Skip pretalx init:  %s${NC}\n" "$([ "$SKIP_PRETALX_INIT" = "1" ] && echo "yes" || echo "no")";
printf "${BLUE}Skip dummy event:   %s${NC}\n" "$([ "$SKIP_DUMMY_EVENT" = "1" ] && echo "yes" || echo "no")";
if [ "$HAS_REQUIRED_INIT_ENV_VARS" = "0" ]; then
    log_warning "Missing required environment variables for pretalx init/create_test_event:$MISSING_INIT_ENV_VARS"
    log_warning "Define them in .devcontainer/devcontainer.json (containerEnv) or your environment."
fi
log_info "Installing pretalx development package..."
if python3 -m pip install --upgrade-strategy eager "pretalx[dev]"; then
    log_success "pretalx installed successfully."
else
    log_error "pretalx installation failed!"
    exit 1
fi

log_info "Installing local plugin in editable mode..."
if python3 -m pip install -e .; then
    log_success "Plugin installed successfully.\n"
else
    log_error "Plugin installation failed!\n"
    exit 1
fi

# Ensure configuration file exists
if [ -f "$CFG_FILE" ]; then
    log_info "Configuration file already exists: $CFG_FILE"
elif [ -f "$TEMPLATE_FILE" ]; then
    log_info "Creating configuration file from template..."
    cp "$TEMPLATE_FILE" "$CFG_FILE"
    log_success "Configuration file created: $CFG_FILE"
else
    log_info "No template file found at $TEMPLATE_FILE, skipping configuration file creation."
fi

log_info "Applying database migrations..."
if python3 -m pretalx migrate; then
    log_success "Migrations applied successfully."
else
    log_error "Migration failed!"
    exit 1
fi

log_info "Collecting static files..."
if python3 -m pretalx collectstatic --noinput; then
    log_success "Static files collected successfully."
else
    log_error "Static file collection failed!"
    exit 1
fi

# Initialize pretalx
if [ "$SKIP_PRETALX_INIT" = "1" ]; then
    log_info "Skipping pretalx init (--skip-pretalx-init flag set)."
elif [ "$HAS_REQUIRED_INIT_ENV_VARS" = "0" ]; then
    log_warning "Skipping pretalx init because required DJANGO_* and PRETALX_INIT_* variables are missing."
else
    log_info "Initializing pretalx..."
    init_output_file="$(mktemp)"
    if python3 -m pretalx init --no-input >"$init_output_file" 2>&1; then
        cat "$init_output_file"
        log_success "Pretalx initialized successfully."
    else
        cat "$init_output_file"
        if grep -Fq "CommandError: Error: That Email is already taken." "$init_output_file"; then
            log_warning "Pretalx init skipped because the configured superuser email already exists. Continuing..."
        else
            log_error "Pretalx initialization failed!"
            rm -f "$init_output_file"
            exit 1
        fi
    fi
    rm -f "$init_output_file"
fi

# Create dummy event
if [ "$SKIP_DUMMY_EVENT" = "1" ]; then
    log_info "Skipping dummy event creation (--skip-dummy-event flag set)."
elif [ "$HAS_REQUIRED_INIT_ENV_VARS" = "0" ]; then
    log_warning "Skipping dummy event creation because required DJANGO_* and PRETALX_INIT_* variables are missing."
else
    log_info "Creating dummy event..."
    create_event_output_file="$(mktemp)"
    if python3 -m pretalx create_test_event >"$create_event_output_file" 2>&1; then
        cat "$create_event_output_file"
        log_success "Dummy event created successfully."
    else
        cat "$create_event_output_file"
        if grep -Fq "django.db.utils.IntegrityError: UNIQUE constraint failed: event_organiser.slug" "$create_event_output_file"; then
            log_warning "Dummy event creation skipped because the organiser slug already exists. Continuing..."
        else
            log_error "Dummy event creation failed!"
            rm -f "$create_event_output_file"
            exit 1
        fi
    fi
    rm -f "$create_event_output_file"
fi

log_setup_complete
