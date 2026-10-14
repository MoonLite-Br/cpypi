# usage:  source ./env.sh
ROOT="$(CDPATH= cd -- "$(dirname "$0")" && pwd)"
export CPY_PATH="$ROOT${CPY_PATH:+:$CPY_PATH}"
echo "CPY_PATH=$CPY_PATH"
