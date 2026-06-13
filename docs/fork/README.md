# Banking Browser fork workflow

This directory contains the local workflow for maintaining this Chromium fork as a
small, replayable product patch stack on top of upstream Chromium.

The goals are:

- keep upstream Chromium updates mechanical;
- avoid committed mass deletions of upstream-owned source trees;
- keep banking-browser code and tooling in fork-owned paths;
- make day-to-day builds use a small checkout and a narrow build target;
- keep an exported patch stack available for audit and replay.

Start with:

1. [Local layout](local_layout.md)
2. [Slim checkout](slim_checkout.md)
3. [Development build args](args/banking_dev_linux.gn)
4. [Patch-stack maintenance](patch_stack.md)
5. [Upstream update workflow](update_workflow.md)

Helper scripts live in `tools/banking_browser/`.
