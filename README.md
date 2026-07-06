# OrgMentem Homebrew Tap

Homebrew formulae for [OrgMentem](https://github.com/OrgMentem) tools.

## Formulae

| Formula | What it is | Install |
| --- | --- | --- |
| `zotio` | Trust-and-automation layer for Zotero — search, export, analytics, safe writes, MCP. | `brew install orgmentem/tap/zotio` |
| `inscribi` | Local-first academic feedback engine for instructor-reviewed marking. | `brew install orgmentem/tap/inscribi` |

`orgmentem/tap/<formula>` is shorthand for:

```bash
brew tap orgmentem/tap      # clones github.com/OrgMentem/homebrew-tap
brew install <formula>
```

## Tap layout

```
homebrew-tap/
  Formula/        # CLI / library formulae
    zotio.rb      # generated + committed by goreleaser on each zotio release
    inscribi.rb   # hand-maintained (git-revision strategy)
  README.md
```

A `Casks/` directory can be added later for `.app`/`.dmg` desktop launchers.

## `zotio`

Installs the `zotio` CLI and the `zotio-mcp` MCP server.

```bash
brew install orgmentem/tap/zotio
zotio --version
```

The formula is **generated and committed automatically by [GoReleaser](https://goreleaser.com/)**
from [`OrgMentem/zotio`](https://github.com/OrgMentem/zotio) (see its `.goreleaser.yaml`
`brews:` block) on each tagged release — do not hand-edit `Formula/zotio.rb`.
To cut a release: push a `vX.Y.Z` tag on `OrgMentem/zotio`; its release workflow
runs GoReleaser, which builds the binaries and pushes the updated formula here.
Users update with `brew update && brew upgrade zotio`.

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
