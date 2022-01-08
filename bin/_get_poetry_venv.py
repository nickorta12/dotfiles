#!/usr/bin/python3
import os

POETRY_DIR = os.path.expanduser("~/Library/Caches/pypoetry/virtualenvs")
poetry_paths = [x for x in os.listdir(POETRY_DIR) if "-py" in x]

cwd = os.path.basename(os.getcwd())
for path in poetry_paths:
    if cwd in path:
        print(os.path.join(POETRY_DIR, path, "bin/activate"))
        exit(0)

exit(1)
