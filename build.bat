@echo off
set BUILD=.\bin
set BIN=FlappyBird.exe

if exist %BUILD% (
    rmdir /s /q %BUILD%
)

mkdir %BUILD%

odin build .\src -out:%BUILD%\%BIN%
