@echo off

python -m pip install --upgrade bs4
python -m pip install --upgrade requests
python -m pip install --upgrade google-api-python-client
python -m pip install --upgrade google-auth-httplib2
python -m pip install --upgrade google-auth-oauthlib

python .\pyrmont\pyrmont.py "."
echo Please, refresh your Rainmeter.
pause
