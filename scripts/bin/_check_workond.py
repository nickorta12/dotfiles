#!/usr/bin/python3
import os

POETRY_DIR = os.path.expanduser("~/Library/Caches/pypoetry/virtualenvs")
VENV_DIR = os.path.expanduser("~/.venv")
poetry_paths = [x for x in os.listdir(POETRY_DIR) if "-py" in x]
venv_paths = os.listdir(VENV_DIR)

cwd = os.path.basename(os.getcwd())
for path in poetry_paths:
    if cwd in path:
        print("POETRY")
        exit(0)
for path in venv_paths:
    if cwd in path:
        print("VENV")
        exit(0)

exit(1)
