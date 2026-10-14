#!/bin/sh
# Install cpypi so `import cpypi` works from any directory.
# Usage:
#   ./install.sh           # user install
#   ./install.sh --print   # only print the path / export line
set -e
cd "$(dirname "$0")"
ROOT="$(pwd)"
PKG="$ROOT/cpypi"

if [ ! -f "$PKG/__init__.cpy" ]; then
  echo "error: cpypi package not found next to install.sh" >&2
  exit 1
fi

# Prefer a stable location on PATH-searchable disk
if [ -n "$PREFIX" ] && [ -d "$PREFIX" ]; then
  DEST="$PREFIX/share/cpypi"
elif [ -d "$HOME" ]; then
  DEST="$HOME/.local/share/cpypi"
else
  DEST="$ROOT"
fi

mkdir -p "$DEST"
# Copy package tree (replace previous install)
rm -rf "$DEST/cpypi"
cp -a "$PKG" "$DEST/cpypi"

# Shell snippet to add permanently
EXPORT_LINE="export CPY_PATH=\"$DEST\${CPY_PATH:+:\$CPY_PATH}\""

add_to_rc() {
  rc="$1"
  if [ -f "$rc" ] && grep -q 'CPY_PATH=.*share/cpypi\|# cpypi' "$rc" 2>/dev/null; then
    echo "already noted in $rc"
    return
  fi
  if [ -f "$rc" ] || [ -w "$(dirname "$rc")" ]; then
    printf '\n# cpypi (HTML parser for cpy)\n%s\n' "$EXPORT_LINE" >> "$rc"
    echo "appended to $rc"
  fi
}

if [ "${1:-}" = "--print" ]; then
  echo "$DEST"
  echo "$EXPORT_LINE"
  exit 0
fi

# Current session
export CPY_PATH="$DEST${CPY_PATH:+:$CPY_PATH}"

# Persist for common shells
if [ -n "$PREFIX" ]; then
  # Termux: also drop a small env hint
  add_to_rc "$HOME/.bashrc" 2>/dev/null || true
  add_to_rc "$HOME/.zshrc" 2>/dev/null || true
else
  add_to_rc "$HOME/.bashrc" 2>/dev/null || true
  add_to_rc "$HOME/.zshrc" 2>/dev/null || true
  add_to_rc "$HOME/.profile" 2>/dev/null || true
fi

echo "Installed cpypi -> $DEST/cpypi"
echo "CPY_PATH includes: $DEST"
echo ""
echo "Try:"
echo "  cpy -c 'import cpypi; print(cpypi.__version__)'"
echo ""
echo "If a new shell does not see it, run:"
echo "  $EXPORT_LINE"
