@echo off

python -m pip install bs4
python -m pip install requests

python .\pyrmont\pyrmont.py "."
echo Please, refresh your Rainmeter.
pause
