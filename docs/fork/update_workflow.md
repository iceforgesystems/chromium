# Upstream update workflow

Use this process whenever moving the fork to a newer Chromium revision or
milestone.

1. Ensure the product branch is clean except for intentional work:

   ```bash
   git status --short
   ```

2. Fetch upstream:

   ```bash
   git fetch upstream
   ```

3. Create the new clean base branch:

   ```bash
   git switch -c banking/base/<new-milestone> upstream/<branch-or-tag>
   gclient sync
   ```

4. Replay the product stack:

   ```bash
   git switch -c banking/product/<new-milestone> banking/base/<new-milestone>
   tools/banking_browser/apply_patches.sh ../banking-browser-patches/patches
   ```

   Alternatively, rebase the old product branch:

   ```bash
   git rebase --onto banking/base/<new-milestone> banking/base/<old-milestone> banking/product/<old-milestone>
   ```

5. Regenerate build files and build the narrow target:

   ```bash
   gn gen out/banking_dev --args="$(cat docs/fork/args/banking_dev_linux.gn)"
   autoninja -C out/banking_dev chrome
   ```

6. Export the refreshed patch stack:

   ```bash
   tools/banking_browser/export_patches.sh banking/base/<new-milestone> ../banking-browser-patches/patches
   ```

7. Keep conflict fixes small and preserve the fork-owned-code rule: prefer new
   code under `components/banking/`, `chrome/browser/banking/`, `docs/fork/`, or
   `tools/banking_browser/` with tiny hooks into upstream-owned files.
