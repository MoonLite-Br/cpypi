#!/bin/sh
# cpypi — one-step setup for `import cpypi`
#
#   git clone https://github.com/MoonLite-Br/cpypi.git
#   cd cpypi
#   ./install.sh
#   cpy -c 'import cpypi; print(cpypi.__version__)'
#
set -e
ROOT="$(CDPATH= cd -- "$(dirname "$0")" && pwd)"
PKG="$ROOT/cpypi"

if [ ! -f "$PKG/__init__.cpy" ]; then
  echo "error: missing $PKG/__init__.cpy" >&2
  exit 1
fi

# Parent of the package dir must be on CPY_PATH
EXPORT="export CPY_PATH=\"$ROOT\${CPY_PATH:+:\$CPY_PATH}\""

# Idempotent line in shell rc files
mark="# cpypi CPY_PATH"
add_rc() {
  f="$1"
  [ -n "$f" ] || return 0
  touch "$f" 2>/dev/null || return 0
  if grep -q "cpypi CPY_PATH\|share/cpypi\|$ROOT" "$f" 2>/dev/null; then
    return 0
  fi
  printf '\n%s\n%s\n' "$mark" "$EXPORT" >> "$f"
  echo "  + $f"
}

echo "cpypi root: $ROOT"

# Persist for next terminals
added=0
for f in "$HOME/.bashrc" "$HOME/.zshrc" "$HOME/.profile"; do
  if [ -e "$f" ] || [ -w "$HOME" ]; then
    before=$(wc -l < "$f" 2>/dev/null || echo 0)
    add_rc "$f"
    after=$(wc -l < "$f" 2>/dev/null || echo 0)
    [ "$after" != "$before" ] && added=1
  fi
done

# Always print the one line that makes *this* shell work
echo ""
echo "Done. In THIS terminal run:"
echo ""
echo "  $EXPORT"
echo ""
echo "Then:"
echo "  cpy -c 'import cpypi; print(cpypi.__version__)'"
echo ""
echo "Note: do not name your script cpypi.cpy — it shadows the package."
