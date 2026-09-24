from pathlib import Path
import re

root = Path(__file__).resolve().parents[1] / 'lib'
for folder in [root / 'domain', root / 'presentation']:
    for path in folder.rglob('*.dart'):
        text = path.read_text(encoding='utf-8')
        checks = {
            "dart:io import": r"import\s+['\"]dart:io['\"]",
            "package:web import": r"import\s+['\"]package:web",
            "Platform member": r"\bPlatform\s*\.",
            "kIsWeb": r"\bkIsWeb\b",
        }
        hits = [name for name, pattern in checks.items() if re.search(pattern, text)]
        if hits:
            raise SystemExit(f'Forbidden platform dependency in {path}: {hits}')
print('Architecture check passed: domain/ and presentation/ are platform independent.')
