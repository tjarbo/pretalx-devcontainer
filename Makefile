# Define the directory containing the scripts
SCRIPTS_DIR := default-scripts
LICENSE_FILE := LICENSE
LICENSE_MARKER := \# LICENSE_MARKER

# Find all .sh files in the scripts directory
SCRIPTS := $(wildcard $(SCRIPTS_DIR)/*.sh)

# Target to inject the license into all .sh scripts
inject-license: $(SCRIPTS)
	@for script in $^; do \
		echo "Injecting license into $$script"; \
		tmpfile=$$script.tmp; \
		touch $$tmpfile; \
		while IFS= read -r line; do \
			if [ "$$line" == "$(LICENSE_MARKER)" ]; then \
				while IFS= read -r license_line; do \
					echo "# $$license_line" >> $$tmpfile; \
				done < $(LICENSE_FILE); \
				echo "#" >> $$tmpfile; \
			else \
				echo "$$line" >> $$tmpfile; \
			fi; \
		done < $$script; \
		mv $$tmpfile $$script; \
	done;

# Phony target
.PHONY: inject-license
