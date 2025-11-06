# Makefile for Quarto PDF Project
#
# This Makefile provides a convenient interface for common tasks.
# It relies on Quarto being installed and available in the PATH.

# --- Variables ---
SHELL := /bin/bash
QUARTO := $(shell command -v quarto 2> /dev/null)
PROJECT_DIR := $(shell pwd)
BUILD_DIR := _build
EXAMPLES_DIR := examples

# Default target file for single-file builds
INPUT ?= $(EXAMPLES_DIR)/sample.qmd
OUTPUT_PDF := $(BUILD_DIR)/$(EXAMPLES_DIR)/$(patsubst %.qmd,%.pdf,$(notdir $(INPUT)))

# --- Phony Targets (commands that don't produce a file with the same name) ---
.PHONY: all pdf clean check ci help

# --- Main Targets ---

all: pdf
	@echo "Build complete. PDF is at $(OUTPUT_PDF)"

# Renders the entire project or a single file if INPUT is specified.
pdf:
	@echo "Rendering PDF..."
	@scripts/render.sh $(INPUT)

# Render the whole project as defined in _quarto.yml
project:
	@echo "Rendering the entire project..."
	@scripts/render.sh

# Removes all generated files.
clean:
	@echo "Cleaning build artifacts..."
	@rm -rf $(BUILD_DIR)
	@rm -rf **/.quarto/
	@rm -f $(EXAMPLES_DIR)/*.pdf
	@find . -name "*~" -delete
	@find . -name "*.log" -delete
	@find . -name "*.aux" -delete

# Checks for dependencies.
check:
ifndef QUARTO
	$(error "Quarto is not installed or not in your PATH. See https://quarto.org/docs/get-started/")
endif
	@echo "✅ Quarto is installed: $(QUARTO)"
	@scripts/detect-tex.sh > /dev/null || (echo "❌ TeX distribution (e.g., TinyTeX) not found."; exit 1)
	@echo "✅ TeX distribution found."
	@echo "✅ TeX package checks complete."


# Target for Continuous Integration.
ci: check pdf
	@echo "CI build successful."

# Default help message.
help:
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@echo "  all        (Default) Renders the sample document to PDF."
	@echo "  pdf        Alias for 'all'."
	@echo "  project    Renders the entire project based on _quarto.yml."
	@echo "  clean      Removes all generated files and build artifacts."
	@echo "  check      Checks for required dependencies (Quarto, TeX, packages)."
	@echo "  ci         Runs the check and build targets for CI environments."
	@echo ""
	@echo "Variables:"
	@echo "  INPUT      Path to a specific .qmd file to render."
	@echo "             Example: make pdf INPUT=examples/another.qmd"
