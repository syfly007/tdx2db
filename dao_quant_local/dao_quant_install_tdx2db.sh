#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: dao_quant_install_tdx2db.sh [--dir INSTALL_DIR] [--skip-check]

Build and install this vendored tdx2db checkout to the local machine.

Options:
  --dir INSTALL_DIR  Install directory. Default: $HOME/.local/bin
  --skip-check       Do not run "tdx2db -h" after install
  -h, --help         Show this help

Examples:
  ./dao_quant_local/dao_quant_install_tdx2db.sh
  ./dao_quant_local/dao_quant_install_tdx2db.sh --dir /usr/local/bin
EOF
}

install_dir="${HOME}/.local/bin"
skip_check=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dir)
      if [[ $# -lt 2 || -z "${2:-}" ]]; then
        echo "error: --dir requires a value" >&2
        exit 2
      fi
      install_dir="$2"
      shift 2
      ;;
    --skip-check)
      skip_check=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "error: unknown argument: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
repo_dir="$(cd -- "${script_dir}/.." && pwd)"

require_cmd() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "error: required command not found: $1" >&2
    exit 1
  fi
}

require_cmd go
require_cmd make
require_cmd curl
require_cmd unrar

mkdir -p "${install_dir}"

echo "Building and installing tdx2db from ${repo_dir}"
echo "Install directory: ${install_dir}"

make -C "${repo_dir}" user-install LOCAL_BIN="${install_dir}"

if [[ "${skip_check}" -eq 0 ]]; then
  "${install_dir}/tdx2db" -h >/dev/null
  echo "Installed: ${install_dir}/tdx2db"
else
  echo "Installed without post-install check: ${install_dir}/tdx2db"
fi

case ":${PATH}:" in
  *":${install_dir}:"*) ;;
  *)
    echo "NOTE: ${install_dir} is not currently in PATH."
    echo "Add it to your shell profile if you want to run tdx2db without an absolute path."
    ;;
esac
