# Slim checkout profile

Do not streamline the fork by committing large deletions of upstream Chromium
source trees. Prefer Chromium's existing `gclient` and `DEPS` knobs so upstream
updates remain easy.

Example `.gclient` solution for a Linux-first development checkout:

```python
solutions = [
  {
    "name": "src",
    "url": "https://chromium.googlesource.com/chromium/src.git",
    "managed": False,
    "custom_vars": {
      "checkout_configuration": "small",
      "checkout_clang_coverage_tools": False,
      "checkout_clang_tidy": False,
      "checkout_clangd": False,
      "checkout_js_coverage_modules": False,
      "checkout_pgo_profiles": False,
      "checkout_telemetry_dependencies": False,
      "skip_wpr_archives_download": True,
    },
  },
]

target_os = ["linux"]
```

Adjust `url` to your hosted fork when bootstrapping a new machine. Add other
`target_os` entries only when actively developing those platforms.

Useful generated/local cleanup targets include:

- `out/`
- `third_party/material_web_components/node_modules/`
- `third_party/android_deps/build/`
- local coverage reports and temporary test outputs

Use `tools/banking_browser/clean_generated.sh --dry-run` before deleting local
artifacts.
