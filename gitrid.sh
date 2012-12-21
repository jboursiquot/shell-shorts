#!/bin/bash
die () {
  echo >&2 "$@"
  exit 1
}
[ "$#" -eq 1 ] || die "1 argument required, $# provided"

echo "Purging '$1' history from repo..."
echo
cmd="git filter-branch --index-filter 'git rm --cached --ignore-unmatch $1' --prune-empty --tag-name-filter cat -- --all"
eval ${cmd}

echo
echo "Cleaning up..."
echo
rm -rf .git/refs/original/
git reflog expire --expire=now --all
git gc --prune=now
git gc --aggressive --prune=now

echo
echo "Done. Add $1 to your .gitignore file to keep it from the repo in the future."
