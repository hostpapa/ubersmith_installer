#!/usr/bin/env bash
set -e

# Find the newest Python to use

export PATH="$HOME/.local/bin:$HOME/.local/ubersmith_venv/bin:$PATH"

rm -rf $HOME/.local/ubersmith_venv

echo "Checking for Python 3.11 or newer..."

PYTHON_BIN=""
NEWEST_VERSION=""

for pybin in $(compgen -c python3 | grep -E '^python3(\.[0-9]+)?$' | sort -u); do
    command -v "$pybin" &> /dev/null || continue
    "$pybin" -c 'import sys; exit(0 if sys.version_info >= (3, 11) else 1)' 2>/dev/null || continue
    VERSION=$("$pybin" -c 'import sys; print(".".join(map(str, sys.version_info[:3])))')
    if [ -z "$NEWEST_VERSION" ] || [ "$(printf '%s\n' "$NEWEST_VERSION" "$VERSION" | sort -V | tail -n1)" = "$VERSION" ]; then
        NEWEST_VERSION=$VERSION
        PYTHON_BIN=$pybin
    fi
done

if [ -z "$PYTHON_BIN" ]; then
    echo "Error: no Python 3.11 or newer found in your PATH. Please install Python 3.11+ and try again."
    exit 1
fi

echo "Using $PYTHON_BIN ($NEWEST_VERSION)"
