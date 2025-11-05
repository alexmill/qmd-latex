#!/bin/bash
#
# detect-tex.sh: Finds the path to the xelatex executable.
#
# This script prioritizes TinyTeX but falls back to other common locations.
# It's designed to be called by other scripts like render.sh.
set -e

# --- Search Paths ---
# 1. User's TinyTeX installation (most common)
TINYTEX_PATH="$HOME/.TinyTeX/bin/x86_64-linux/xelatex" # Linux
if [[ "$(uname)" == "Darwin" ]]; then
  TINYTEX_PATH="$HOME/Library/TinyTeX/bin/universal-darwin/xelatex" # macOS
fi

# 2. System-wide TeX Live (common on Linux)
TEXLIVE_PATH="/usr/bin/xelatex"

# 3. MacTeX (common on macOS)
MACTEX_PATH="/usr/local/texlive/bin/universal-darwin/xelatex"

# --- Detection Logic ---
if [ -x "$TINYTEX_PATH" ]; then
  echo "$TINYTEX_PATH"
  exit 0
elif command -v xelatex &>/dev/null; then
  # If `xelatex` is in the PATH, use that.
  command -v xelatex
  exit 0
elif [ -x "$MACTEX_PATH" ]; then
  echo "$MACTEX_PATH"
  exit 0
elif [ -x "$TEXLIVE_PATH" ]; then
  echo "$TEX_LIVE_PATH"
  exit 0
fi

# If we reach here, no executable was found.
exit 1
