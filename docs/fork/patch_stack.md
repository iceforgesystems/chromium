# Patch-stack maintenance

The source of truth for product work is the Git branch
`banking/product/<milestone>`. Exported patches are a replayable representation
of that branch for audit, review, and update testing.

Keep commits focused and ordered by product area. Example stack:

```text
0001-docs-add-fork-workflow-and-build-profile.patch
0002-build-add-banking-browser-feature-flags.patch
0003-profile-add-hardened-defaults.patch
0004-navigation-add-domain-allowlist-service.patch
0005-navigation-enforce-allowlist.patch
0006-extensions-restrict-install-sources.patch
0007-extensions-add-private-store-update-url.patch
```

Export patches from the current product branch:

```bash
tools/banking_browser/export_patches.sh banking/base/<milestone> ../banking-browser-patches/patches
```

Replay patches on a clean base branch:

```bash
git switch -c test/replay banking/base/<milestone>
tools/banking_browser/apply_patches.sh ../banking-browser-patches/patches
```

If a patch conflicts during an upstream update, fix that conceptual patch only.
Do not mix unrelated cleanup or feature work into conflict-resolution commits.
