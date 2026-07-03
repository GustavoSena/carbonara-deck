# Carbonara presenter deck — GitHub Pages

Self-contained slide deck (`index.html`) plus the seven segment videos in `segments/`.
Because the videos sit next to the HTML and the deck uses relative paths, hosting this
folder on GitHub Pages "just works" — real `.mp4` URLs, native player, autoplay per slide.

## Fastest way to publish (one command)

Requires the GitHub CLI once: install from https://cli.github.com then `gh auth login`.

```bash
cd carbonara-site
bash deploy.sh                 # creates a public repo named "carbonara-deck"
# bash deploy.sh my-repo-name  # ...or choose your own repo name
```

When it finishes it prints the live URL: `https://<your-username>.github.io/carbonara-deck/`
(give it ~1 minute the first time).

## Manual way (no gh CLI)

```bash
cd carbonara-site
git init && git add -A && git commit -m "Carbonara deck"
git branch -M main
# create an EMPTY public repo on github.com first, then:
git remote add origin https://github.com/<you>/carbonara-deck.git
git push -u origin main
```

Then on github.com: **repo → Settings → Pages → Source: Deploy from a branch →
Branch: `main` / `/ (root)` → Save.** Live at `https://<you>.github.io/carbonara-deck/`.

## Notes

- Videos are H.264 1080p, remuxed with `+faststart` so they stream instantly.
- Largest clip is 54 MB — under GitHub's 100 MB per-file limit, so **no Git LFS needed.**
- Total ~236 MB; well under the 1 GB Pages recommendation.
- `.nojekyll` is included so Pages serves files as-is.
- The repo is **public**, so the deck and clips are publicly reachable by URL (not indexed,
  but not private). If the footage shouldn't be public, use an unlisted host instead.
