# OrgMentem Homebrew Tap

Homebrew formulae for [OrgMentem](https://github.com/OrgMentem) tools.

## Formulae

| Formula | What it is | Status |
| --- | --- | --- |
| `zotio` | Trust-and-automation layer for Zotero — search, library health, safe writes, annotation export, MCP. | **Available** — `brew install orgmentem/tap/zotio` (current: v0.1.0). |
| `inscribi` | Local-first academic feedback engine for instructor-reviewed marking. | **Not yet published** — source repo is private and it is not on PyPI (see below). |

Install a published formula with `brew install orgmentem/tap/<formula>`,
which is shorthand for:

```bash
brew tap orgmentem/tap      # clones github.com/OrgMentem/homebrew-tap
brew install <formula>
```

## Tap layout

```
homebrew-tap/
  Formula/        # CLI / library formulae
    zotio.rb      # rendered by goreleaser; currently committed manually per release
    inscribi.rb   # hand-maintained (git-revision strategy)
  README.md
```

A `Casks/` directory can be added later for `.app`/`.dmg` desktop launchers.

## `zotio`

Installs the `zotio` CLI and the `zotio-mcp` MCP server:

```bash
brew install orgmentem/tap/zotio
zotio version
```

Users update with `brew update && brew upgrade zotio`.

### Maintaining the `zotio` formula

`Formula/zotio.rb` mirrors what [GoReleaser](https://goreleaser.com/) renders from
[`OrgMentem/zotio`](https://github.com/OrgMentem/zotio) (`.goreleaser.yaml`, `brews:`
block). The release workflow currently runs with `skip_upload: true` because the
default `GITHUB_TOKEN` cannot push cross-repo, so on each tagged release the
formula is updated **manually**: copy the rendered formula, or update `version`,
the URLs, and the four `sha256` values from the release's `checksums.txt`.

To make this automatic: add a fine-grained PAT (Contents: read/write on this repo
only) to `OrgMentem/zotio` as the `HOMEBREW_TAP_GITHUB_TOKEN` Actions secret and
flip `skip_upload` to `false` — from then on GoReleaser commits here on every
`vX.Y.Z` tag and `Formula/zotio.rb` must no longer be hand-edited.

## `inscribi`

The formula installs `inscribi` from its source repo via [`uv`](https://docs.astral.sh/uv/),
which resolves the full (heavy, partly non-PyPI) dependency tree and honors the
`[tool.uv.sources]` model wheel. Two things currently limit who can install it:

1. **Source repo is private.** `github.com/enieuwy/inscribi` is private, so
   `brew install` only succeeds for machines with git access to that repo. For
   public/non-dev distribution, make the source repo public or publish a release
   artifact.
2. **Not on PyPI.** There is no `pip install inscribi`; install goes through the
   git source. Publishing to PyPI would let the formula switch to a standard
   `uv tool install inscribi` without git access.

### Maintaining the `inscribi` formula

The formula tracks a specific commit on the source repo (git download strategy,
so there is no tarball `sha256` to recompute). For each release:

1. Push the release commit to the source repo `main` (or a tag).
2. Edit `Formula/inscribi.rb`: set `revision:` to the new commit SHA and
   `version` to the new project version.
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
