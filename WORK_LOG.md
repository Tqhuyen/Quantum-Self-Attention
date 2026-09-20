# Enhancing Quantum Self-Attention — PR #1861 Work Log

**PR:** https://github.com/PennyLaneAI/demos/pull/1861 (base `master`, head `enhancing-quantum-self-attention` in fork `Tqhuyen/demos`)
**Status:** Marked ready for review (2026-09-20). CI re-running for latest revision (`886ae4a`).
**Latest pushed commit:** `886ae4a` — "Use registered pennylane.ai username for first author"

## Root Cause Found and Fixed (RST section errors)

The docutils `CRITICAL/ERROR: Unexpected section title` messages came from a real
`sphinx-gallery` interaction bug in `demo.py`, not from the build environment:

1. `sphinx-gallery` captures comment lines after a `###...###` header into one text block
   and cleans it with `textwrap.dedent(...).lstrip()`.
2. The `###############` separator line before `# Conclusion` sat **inside** a continuous
   comment block (no code between it and the `How to adapt` section).
3. After `#` stripping, that separator line has zero indentation. `dedent()` then finds a
   common prefix of `''` and removes nothing, while `.lstrip()` only strips the *first*
   line — leaving every following line indented by one space.
4. Result: all sections after `How to adapt` were rendered as indented block quotes and
   docutils reported "Unexpected section title" / "Missing matching underline".

**Fix applied in `demo.py`:**
- Removed the intermediate `#` separator line before `# Conclusion`.
- Promoted `Conclusion` and `References` underlines from `~` to `-` (first-level sections,
  matching other demos).
- Regenerated the RST via `sphinx_gallery.py_source_parser.split_code_and_text_blocks` and
  confirmed **0 structural docutils errors**; built HTML with Sphinx and confirmed all
  sections render (only expected warning: `:doc:` cross-reference in the minimal test project).

## Additional Fixes

### Metadata (`metadata.json`)
- `dateOfLastModification` → `2026-09-20T12:00:00+00:00` (per the GitHub Actions reminder bot).
- **Authors:** first author now uses the registered pennylane.ai username `Tqhuyen`
  (verified at https://pennylane.ai/profile/Tqhuyen); the four co-authors remain schema-valid
  `name`-only entries. **Important:** `name` + `username` together is **invalid** under
  `author.schema.0.2.0.json` (`oneOf` with `additionalProperties: false`); validated locally
  with a ref-resolving `Draft202012Validator` (0 errors).

### Demo content (`demo.py`)
- Cited `[#QSANM]` in the intro (was defined but never referenced → footnote warning).
- Smoke tests: 2 samples / 2 epochs → runs end-to-end, prints final accuracies.

## CI Status (GitHub Actions)
- Previous revision `0de17f6`: **all checks pass**, including `build / build-demos (0)` (55m34s,
  executes the demo: `execute` defaults to `true`) and `validate-metadata` schema check.
- Current revision `5777972`: CI re-running after push.
- Note: this PR targets `master`, so only the **stable** dependency mode runs; the `dev`
  matrix entry runs only for PRs targeting the `dev` branch. Local Kaggle attempts at `dev`
  failed on an environment issue (`pip index versions pennylane-catalyst` against
  `test.pypi.org`), not on demo code.

## Environment Fixes (local machine)
- Installed `sphinx`, `sphinx-gallery`, `check-jsonschema`, `pennylane-lightning`,
  `h5py`, `fsspec`, `aiohttp` with `python -m pip install --user ...`
  (`--user` avoids a Windows permission error writing `C:\Python312\Scripts\*.exe`).
- `rebuild_all.sh` updated to use `python -m pip` (bare `pip` not on PATH).

## Remaining Before Merge (review-coordinated)
1. Optional: pennylane.ai usernames for the four co-authors (first author `Tqhuyen` is set;
   schema: `username` **or** `name` per author, never both).
2. Replace the placeholder thumbnail with final regular/large thumbnails
   (`_static/demo_thumbnails/{regular,large}_demo_thumbnails/...`).
3. Maintainer review and any requested changes.

## Files Changed in the PR (latest commit)
- `demonstrations_v2/enhancing_quantum_self_attention_with_circuit_classifiers/demo.py`
- `demonstrations_v2/enhancing_quantum_self_attention_with_circuit_classifiers/metadata.json`

## Local Helper Artifacts (not part of the PR)
- `C:\Users\huyen\AppData\Local\Temp\opencode\demos\validate_metadata_local.py` —
  ref-resolving metadata validator for Windows.
- `C:\Users\huyen\AppData\Local\Temp\opencode\qsa_smoke_test2.py` — reduced-budget smoke test.
- `C:\Users\huyen\AppData\Local\Temp\opencode\generated_from_demo_fixed.rst` — regenerated RST.
- `C:\Users\huyen\AppData\Local\Temp\opencode\qsa_html_test2\` — local Sphinx HTML build.
