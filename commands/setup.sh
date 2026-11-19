#!/usr/bin/env bash
set -e

echo "Testing custom script execution!"
echo "User: $USER"
echo "Home: $HOME"

# Test inline logic (no sudo required for test)
if command -v git &>/dev/null; then
    echo "✅ Git is installed"
else
    echo "❌ Git is missing"
fi
