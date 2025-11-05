#!/bin/bash
#
# render.sh: A POSIX-compliant script to render Quarto/Pandoc documents.
#
# This script provides a fallback mechanism if 'make' is not available.
# It detects the rendering engine (Quarto or Pandoc) and the TeX distribution.
#
set -e # Exit immediately if a command exits with a non-zero status.
set -u # Treat unset variables as an error.

# --- Helper Functions ---
info() {
  echo "[INFO] $1"
}

error() {
  echo "[ERROR] $1" >&2
  exit 1
}

# --- Variable Defaults ---
INPUT_FILE=""
OUTPUT_FORMAT="pdf"
RENDER_ENGINE=""
TEX_ENGINE=""

# --- Detect Rendering Engine (Quarto preferred) ---
if command -v quarto &>/dev/null; then
  RENDER_ENGINE="quarto"
elif command -v pandoc &>/dev/null; then
  RENDER_ENGINE="pandoc"
else
  error "Neither Quarto nor Pandoc found in PATH. Please install one."
fi
info "Using render engine: $RENDER_ENGINE"

# --- Detect TeX Distribution ---
# Use a helper script to find the TeX engine path
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
TEX_ENGINE_PATH_CMD="$SCRIPT_DIR/detect-tex.sh"

if ! TEX_ENGINE=$($TEX_ENGINE_PATH_CMD); then
    error "Could not find a TeX distribution (like TinyTeX). Please install one."
fi
info "Found TeX engine: $TEX_ENGINE"

# --- Parse Command-Line Arguments ---
if [ $# -eq 0 ]; then
  info "No input file specified. Trying to render project defined in _quarto.yml"
else
  INPUT_FILE=$1
  if [ ! -f "$INPUT_FILE" ]; then
    error "Input file not found: $INPUT_FILE"
  fi
  info "Target input file: $INPUT_FILE"
fi

# --- Build Command ---
CMD=""
if [ "$RENDER_ENGINE" = "quarto" ]; then
  CMD="quarto render"
  if [ -n "$INPUT_FILE" ]; then
    CMD="$CMD $INPUT_FILE"
  fi
  CMD="$CMD --to $OUTPUT_FORMAT"

elif [ "$RENDER_ENGINE" = "pandoc" ]; then
  # This is a simplified Pandoc path. A real implementation would need
  # to replicate the logic from _quarto.yml (filters, templates, etc.).
  # This is non-trivial and why Quarto is preferred.
  info "Pandoc rendering is complex; this is a basic example."
  if [ -z "$INPUT_FILE" ]; then
    error "Pandoc requires an explicit input file."
  fi
  OUTPUT_FILE="${INPUT_FILE%.*}.pdf"
  CMD="pandoc $INPUT_FILE -o $OUTPUT_FILE \
    --from markdown \
    --template=template/template.tex \
    --listings \
    --pdf-engine=$TEX_ENGINE"
fi

# --- Execute Render Command ---
info "Executing: $CMD"
eval "$CMD"
info "Render complete."
