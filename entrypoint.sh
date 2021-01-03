#!/bin/sh

python myapp/manage.py migrate --no-input
python myapp/manage.py collectstatic --no-input

gunicorn --bind 0.0.0.0:8000 --chdir /myproject/myapp myapp.wsgi:application
