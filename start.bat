@echo off
cd /d "%~dp0public"
echo Forecast Desk running at http://localhost:8901
start http://localhost:8901
python -m http.server 8901
