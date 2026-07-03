#!/usr/bin/env bash
# One-shot: create a PUBLIC GitHub repo, push this folder, enable GitHub Pages.
# Run this from inside the carbonara-site folder:  bash deploy.sh
set -euo pipefail

REPO_NAME="${1:-carbonara-deck}"   # optional: pass a different name -> bash deploy.sh my-name

# --- checks -----------------------------------------------------------------
command -v git >/dev/null || { echo "git not found. Install git first."; exit 1; }
command -v gh  >/dev/null || { echo "GitHub CLI (gh) not found. Install: https://cli.github.com  then run: gh auth login"; exit 1; }
gh auth status >/dev/null 2>&1 || { echo "Not logged in. Run: gh auth login"; exit 1; }

cd "$(dirname "$0")"
OWNER="$(gh api user -q .login)"

# --- commit ----------------------------------------------------------------
if [ ! -d .git ]; then git init -q; fi
git add -A
git commit -q -m "Carbonara presenter deck + segment videos" || echo "(nothing new to commit)"
git branch -M main

# --- create public repo + push ---------------------------------------------
if gh repo view "$OWNER/$REPO_NAME" >/dev/null 2>&1; then
  echo "Repo $OWNER/$REPO_NAME already exists — pushing to it."
  git remote add origin "https://github.com/$OWNER/$REPO_NAME.git" 2>/dev/null || true
  git push -u origin main
else
  gh repo create "$REPO_NAME" --public --source=. --remote=origin --push
fi

# --- enable Pages (main branch, root) --------------------------------------
gh api -X POST "repos/$OWNER/$REPO_NAME/pages" \
  -f "source[branch]=main" -f "source[path]=/" >/dev/null 2>&1 \
  && echo "Pages enabled." \
  || echo "Could not auto-enable Pages (may already be on, or needs UI). Settings > Pages > Branch: main / root."

echo
echo "Done. Your deck will be live in ~1 minute at:"
echo "   https://$OWNER.github.io/$REPO_NAME/"
