# Define the directory containing the scripts
SCRIPTS_DIR := container/default-scripts
LICENSE_FILE := LICENSE
LICENSE_MARKER := \# LICENSE_MARKER

# Find all .sh files in the scripts directory
SCRIPTS := $(wildcard $(SCRIPTS_DIR)/post-*.sh)
SCRIPTS += $(wildcard $(SCRIPTS_DIR)/plugin-development/post-*.sh)

# Target to inject the license into all .sh scripts
inject-license: $(SCRIPTS)
	@for script in $^; do \
		echo "Injecting license into $$script"; \
		tmpfile=$$(mktemp); \
		while IFS= read -r line; do \
			if [ "$$line" = "$(LICENSE_MARKER)" ]; then \
				while IFS= read -r license_line; do \
					printf '%s\n' "# $$license_line" >> "$$tmpfile"; \
				done < $(LICENSE_FILE); \
				printf '%s\n' "#" >> "$$tmpfile"; \
			else \
				printf '%s\n' "$$line" >> "$$tmpfile"; \
			fi; \
		done < "$$script"; \
		cat "$$tmpfile" > "$$script"; \
		rm -f "$$tmpfile"; \
	done;

# Phony target
.PHONY: inject-license
