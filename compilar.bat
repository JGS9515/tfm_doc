@echo off
echo ========================================
echo Compilando documento LaTeX...
echo ========================================

cd /d "%~dp0"

echo.
echo [1/4] Primera pasada de pdflatex...
pdflatex -interaction=nonstopmode main.tex >nul 2>&1

echo.
echo [2/4] Ejecutando BibTeX para procesar bibliografia...
bibtex main

echo.
echo [3/4] Segunda pasada de pdflatex...
pdflatex -interaction=nonstopmode main.tex >nul 2>&1

echo.
echo [4/4] Tercera pasada de pdflatex...
pdflatex -interaction=nonstopmode main.tex >nul 2>&1

echo.
echo ========================================
echo Compilacion completada!
echo El archivo main.pdf ha sido actualizado.
echo ========================================
pause
