#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PYTHON_SPEC="${PYTHON_BIN:-${UV_PYTHON_VERSION:-3.10}}"
VENV_DIR="${PKU2026_VENV:-$ROOT_DIR/.venv}"
HOST="${PKU2026_RECOGNIZER_HOST:-127.0.0.1}"
PORT="${PKU2026_RECOGNIZER_PORT:-8799}"
APP_FILE="$ROOT_DIR/app.py"

if ! command -v uv >/dev/null 2>&1; then
  echo "error: uv not found" >&2
  echo "hint: install uv, then rerun this script" >&2
  exit 1
fi

echo "preparing virtualenv with uv: $VENV_DIR"
uv venv --allow-existing --python "$PYTHON_SPEC" "$VENV_DIR"

SYNC_ARGS=(sync --project "$ROOT_DIR" --active --frozen --no-install-project --no-dev)
if [[ "${FORCE_REINSTALL:-0}" == "1" ]]; then
  SYNC_ARGS+=(--reinstall)
fi

echo "syncing dependencies with uv"
VIRTUAL_ENV="$VENV_DIR" PATH="$VENV_DIR/bin:$PATH" uv "${SYNC_ARGS[@]}"

echo "starting PKU2026 recognizer API on ${HOST}:${PORT}"
echo "healthz: http://${HOST}:${PORT}/healthz"
echo "endpoint: http://${HOST}:${PORT}/recognize"

export PKU2026_RECOGNIZER_HOST="$HOST"
export PKU2026_RECOGNIZER_PORT="$PORT"

exec "$VENV_DIR/bin/python" "$APP_FILE"
