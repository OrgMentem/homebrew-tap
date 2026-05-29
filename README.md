# OrgMentem Homebrew Tap

Homebrew formulae for OrgMentem tools.

## Install

```bash
brew install orgmentem/tap/inscribi
```

This is shorthand for:

```bash
brew tap orgmentem/tap          # clones github.com/OrgMentem/homebrew-tap
brew install inscribi
```

After install, launch the browser UI from a project directory:

```bash
cd ~/Marking/PSYC101
inscribi serve --host 127.0.0.1 --port 8080
# then open http://127.0.0.1:8080
```

## Tap layout

```
homebrew-tap/
  Formula/        # CLI / library formulae
    inscribi.rb
  README.md
```

A `Casks/` directory can be added later for `.app`/`.dmg` desktop launchers.

## Prerequisites for `inscribi` to install today

The formula installs `inscribi` from its source repo via [`uv`](https://docs.astral.sh/uv/),
which resolves the full (heavy, partly non-PyPI) dependency tree and honors the
`[tool.uv.sources]` model wheel. Two things currently limit who can install it:

1. **Source repo is private.** `github.com/enieuwy/inscribi` is private, so
   `brew install` only succeeds for machines with git access to that repo. For
   public/non-dev distribution, make the source repo public or publish a release
   artifact (see below).
2. **Not on PyPI.** There is no `pip install inscribi`; install goes through the
   git source. Publishing to PyPI would let the formula switch to a standard
   `uv tool install inscribi` without git access.

## Maintaining the `inscribi` formula

The formula tracks a specific commit on the source repo (git download strategy,
so there is no tarball `sha256` to recompute). For each release:

1. Push the release commit to `enieuwy/inscribi` `main` (or a tag).
2. Edit `Formula/inscribi.rb`:
   - set `revision:` to the new commit SHA,
   - set `version` to the new project version.
3. Validate and smoke-test locally:

   ```bash
   ruby -c Formula/inscribi.rb
   brew style Formula/inscribi.rb
   brew install --build-from-source Formula/inscribi.rb
   brew test inscribi
   ```

4. Commit and push. Users update with `brew update && brew upgrade inscribi`.

> Note: the first install downloads a managed CPython plus a large dependency
> tree (torch via docling, spaCy, etc.), so expect a multi-minute, multi-GB
> initial install.
