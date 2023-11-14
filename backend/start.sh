#!/bin/sh
set -e

export PYTHONPATH=$(pwd):$PYTHONPATH

mkdir -p alembic/versions
alembic revision --autogenerate -m "first"
alembic upgrade head

python3 utils/load_countries.py
python3 utils/load_codes.py
python3 utils/load_flags.py
python3 utils/load_images.py BG
python3 utils/load_current_country.py

uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload