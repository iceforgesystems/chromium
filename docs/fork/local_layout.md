# Recommended local layout

Keep Chromium as a real Git checkout and maintain fork changes as a small series
of commits on top of a clean upstream base. Export patch files as an audit/replay
artifact, not as the only source of truth.

Recommended filesystem layout:

```text
~/browser-work/
  depot_tools/                  # Chromium tooling

  chromium-upstream/
    src/                        # clean upstream checkout, optional but useful

  banking-browser/
    src/                        # active fork checkout; develop and build here

  banking-browser-patches/
    patches/                    # exported git-format-patch files
    series                      # optional ordered patch list
    README.md
```

Recommended remotes in `banking-browser/src`:

```text
origin      your hosted Chromium fork
upstream    official Chromium remote or trusted mirror
```

Recommended branch pattern:

```text
upstream/main or upstream/<milestone>
    -> banking/base/<milestone>
    -> banking/product/<milestone>
```

The base branch should stay as close as possible to upstream. Product changes
belong on `banking/product/<milestone>` and should be split into focused commits.
