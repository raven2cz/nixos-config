#!/usr/bin/env bash
# scripts/nix-update.sh
# Update flake inputs + rebuild via nh, commit/push flake.lock, clean old gens.

set -euo pipefail

# ---- Config (můžeš upravit) ----
KEEP_GENS="${KEEP_GENS:-5}"                  # kolik generací ponechat
COMMIT_MSG_PREFIX="${COMMIT_MSG_PREFIX:-flake: update inputs}"
FALLBACK_FLAKE="${FALLBACK_FLAKE:-}"         # např. "/home/<user>/nixos-config#desktop" (volitelné)

# ---- Helpers ----
die() { echo "ERR: $*" >&2; exit 1; }
need() { command -v "$1" >/dev/null 2>&1 || die "Missing command: $1"; }

need git
need sudo
need nh

# Najdi git root (repo musí být klonované)
REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || true)"
[[ -n "$REPO_ROOT" ]] || die "Run inside git repo (nixos-config) or cd there first."

cd "$REPO_ROOT"

# Zjisti flake ref:
# 1) pokud je předán jako 1. parametr → použijeme (např. ~/nixos-config#desktop)
# 2) jinak pokud je nastaven NH_OS_FLAKE → použijeme
# 3) jinak pokud je nastaven FALLBACK_FLAKE → použijeme
# 4) jinak necháme nh použít programs.nh.flake (pokud je v systému nastaven)
FLAKE_ARG="${1:-}"
if [[ -n "$FLAKE_ARG" ]]; then
  TARGET="$FLAKE_ARG"
elif [[ -n "${NH_OS_FLAKE:-}" ]]; then
  TARGET="$NH_OS_FLAKE"
elif [[ -n "$FALLBACK_FLAKE" ]]; then
  TARGET="$FALLBACK_FLAKE"
else
  TARGET=""  # nh si vezme flake z programs.nh.flake
fi

echo "==> Repo:         $REPO_ROOT"
echo "==> Flake target: ${TARGET:-'<programs.nh.flake / NH_OS_FLAKE>'}"
echo "==> Keep gens:    $KEEP_GENS"
echo

# 1) TEST s updatem vstupů (neaktivuje systém; jen přegeneruje flake.lock a vybuildí)
echo "==> nh os test --update ..."
if [[ -n "$TARGET" ]]; then
  sudo nh os test --update "$TARGET"
else
  sudo nh os test --update
fi

# 2) SWITCH bez --update (aktivuje to, co se otestovalo)
echo "==> nh os switch ..."
if [[ -n "$TARGET" ]]; then
  sudo nh os switch "$TARGET"
else
  sudo nh os switch
fi

# 3) Commit & push flake.lock (jen pokud se změnil)
if git -C "$REPO_ROOT" status --porcelain | grep -q "^ M flake.lock\|^?? flake.lock"; then
  echo "==> Commit flake.lock ..."
  git add flake.lock
  git commit -m "${COMMIT_MSG_PREFIX} ($(date +%F))"
  echo "==> Push ..."
  git push
else
  echo "==> flake.lock unchanged; nothing to commit."
fi

# 4) Úklid starých generací
echo "==> nh clean all --keep $KEEP_GENS"
sudo nh clean all --keep "$KEEP_GENS"

echo "==> Done."
