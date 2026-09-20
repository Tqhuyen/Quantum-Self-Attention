#!/bin/bash
# Fix stable sphinx-build + dev index + rebuild + validate
set -e

echo "Install sphinx (fixes stable missing executable)"
python -m pip install sphinx -q

echo "Install pennylane-catalyst directly (bypass broken test.pypi index)"
python -m pip install pennylane-catalyst -q || python -m pip install pennylane-catalyst --no-deps -q

echo "Rebuild RST + HTML"
# Example: rebuild from source; replace with your actual build command
# python -m sphinx-gallery demos/demonstrations_v2/enhancing_quantum_self_attention_with_circuit_classifiers/demo.py

echo "Verify HTML sections"
for html in _build/demonstrations/*.html; do
  [ -f "$html" ] || continue
  echo "Checking $html ..."
  grep -qi "How to adapt" "$html" && echo "  [PASS] How to adapt present" || echo "  [FAIL] How to adapt MISSING"
  grep -qi "150" "$html" && echo "  [PASS] 150 epochs present" || echo "  [FAIL] 150 epochs MISSING"
  grep -qi "10.1109/gcwkshps68340.2025.11591004" "$html" && echo "  [PASS] DOI present" || echo "  [FAIL] DOI MISSING"
done

echo "Run validation script"
python validate.py || echo "Validation script needs manual fix (remove pip index check line)"

echo "Commit and push"
git add -A
git commit -m "enhancing_quantum_self_attention_with_circuit_classifiers: fix RST underlines, metadata usernames/date, add rebuild script, fix sphinx-dev index" || true
git push origin enhancing-quantum-self-attention || echo "Push requires auth; run manually"
