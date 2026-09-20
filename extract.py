import json, glob, sys

for f in sorted(glob.glob(sys.argv[1])):
    try:
        with open(f, encoding='utf-8') as fh:
            nb = json.load(fh)
    except Exception as e:
        print(f"=== {f} === ERROR: {e}")
        continue
    print(f"=== {f} ===")
    for c in nb['cells']:
        if c['cell_type'] == 'code':
            src = ''.join(c['source'])
            if src.strip():
                print("--CELL--")
                print(src)