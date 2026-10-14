#!/bin/sh
# Setup `import cpypi` for cpy.
#
#   cd cpypi
#   source ./install.sh          # best: sets CPY_PATH in this shell too
#   # or:  ./install.sh          # only writes ~/.bashrc — then open a new terminal
#
# Check:  cpy -c 'import cpypi; print(cpypi.__version__)'
#
# Do NOT name your script cpypi.cpy (it hides this package).

# Resolve repo root (works for both `sh install.sh` and `source install.sh`)
if [ -n "${BASH_SOURCE-}" ]; then
  _CPYPI_HERE="$(CDPATH= cd -- "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
elif [ -n "${ZSH_VERSION-}" ]; then
  _CPYPI_HERE="$(CDPATH= cd -- "$(dirname "$0")" && pwd)"
else
  _CPYPI_HERE="$(CDPATH= cd -- "$(dirname "$0")" && pwd)"
fi

_CPYPI_PKG="$_CPYPI_HERE/cpypi"
if [ ! -f "$_CPYPI_PKG/__init__.cpy" ]; then
  echo "error: missing $_CPYPI_PKG/__init__.cpy" >&2
  unset _CPYPI_HERE _CPYPI_PKG
  return 1 2>/dev/null || exit 1
fi

# Put repo root on CPY_PATH (parent of package folder)
case ":${CPY_PATH-}:" in
  *":$_CPYPI_HERE:"*) ;;
  *) export CPY_PATH="$_CPYPI_HERE${CPY_PATH:+:$CPY_PATH}" ;;
esac

_CPYPI_LINE="export CPY_PATH=\"$_CPYPI_HERE\${CPY_PATH:+:\$CPY_PATH}\""
_CPYPI_MARK="# cpypi CPY_PATH"

_cpypi_add_rc() {
  _f="$1"
  [ -n "$_f" ] || return 0
  touch "$_f" 2>/dev/null || return 0
  if grep -Fq "$_CPYPI_HERE" "$_f" 2>/dev/null; then
    return 0
  fi
  if grep -Fq "$_CPYPI_MARK" "$_f" 2>/dev/null; then
    return 0
  fi
  printf '\n%s\n%s\n' "$_CPYPI_MARK" "$_CPYPI_LINE" >> "$_f"
  echo "saved -> $_f"
}

for _f in "$HOME/.bashrc" "$HOME/.zshrc" "$HOME/.profile"; do
  _cpypi_add_rc "$_f"
done

echo "ok  CPY_PATH has $_CPYPI_HERE"
echo "ok  try:  cpy -c 'import cpypi; print(cpypi.__version__)'"

# If this file was executed (not sourced), remind user to source once
if [ -z "${BASH_SOURCE-}" ] && [ -z "${ZSH_VERSION-}" ]; then
  :
fi
# Detect execute vs source (POSIX-ish): $0 is install.sh when executed
case "$0" in
  *install.sh)
    # likely executed — current shell did NOT get export from child process
    if [ "${0##*/}" = "install.sh" ] && [ ! -n "${BASH_SOURCE-}" ]; then
      # When run as ./install.sh under bash, BASH_SOURCE is still set in bash...
      true
    fi
    ;;
esac

# Bash: BASH_SOURCE only when running under bash
if [ -n "${BASH_VERSION-}" ]; then
  if [ "${BASH_SOURCE[0]}" = "$0" ]; then
    echo ""
    echo "You ran ./install.sh (subshell). Run this once now:"
    echo "  source \"$HOME/.bashrc\""
    echo "or:"
    echo "  source \"$_CPYPI_HERE/install.sh\""
  fi
else
  # plain sh execute always needs the export in parent
  if [ -z "${ZSH_VERSION-}" ]; then
    echo ""
    echo "If import still fails in this terminal:"
    echo "  source \"$_CPYPI_HERE/install.sh\""
    echo "or open a new terminal."
  fi
fi

unset _CPYPI_PKG _CPYPI_LINE _CPYPI_MARK _f _cpypi_add_rc
# keep _CPYPI_HERE only if useful — unset to avoid polluting
unset _CPYPI_HERE
