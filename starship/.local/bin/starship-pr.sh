#!/bin/sh
# Print the PR number for the current branch via gh CLI with a TTL cache.
# Returns non-zero (so starship hides the module) when there's no PR or no
# cache yet; refreshes the cache in the background when stale.

set -e

git rev-parse --is-inside-work-tree >/dev/null 2>&1 || exit 1

branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null) || exit 1
[ -z "$branch" ] || [ "$branch" = "HEAD" ] && exit 1

repo=$(git config --get remote.origin.url 2>/dev/null) || exit 1
[ -z "$repo" ] && exit 1

cache_dir="${TMPDIR:-/tmp}/starship-pr-cache"
mkdir -p "$cache_dir"
key=$(printf '%s__%s' "$repo" "$branch" | tr '/:@ ' '_____' | tr -d '\n')
cache_file="$cache_dir/$key"

ttl=30
now=$(date +%s)
mtime=0
if [ -f "$cache_file" ]; then
  mtime=$(stat -f %m "$cache_file" 2>/dev/null || stat -c %Y "$cache_file" 2>/dev/null || echo 0)
fi
age=$((now - mtime))

if [ "$age" -ge "$ttl" ]; then
  (
    pr=$(gh pr view --json number --jq .number 2>/dev/null || true)
    printf '%s' "$pr" > "$cache_file.tmp" && mv "$cache_file.tmp" "$cache_file"
  ) </dev/null >/dev/null 2>&1 &
fi

if [ -s "$cache_file" ]; then
  cat "$cache_file"
else
  exit 1
fi
