@echo off
REM 用 Godot 运行游戏。请把下面路径改成你电脑上 Godot 的安装位置。
set GODOT_EXE=
if defined GODOT_EXE (
    "%GODOT_EXE%" --path "%~dp0"
) else (
    echo 请先安装 Godot 4 并任选一种方式运行：
    echo.
    echo 方式一：用 Godot 编辑器打开项目
    echo   1. 打开 Godot 引擎
    echo   2. 点击「导入」或「打开」，选择本文件夹里的 project.godot
    echo   3. 在编辑器中按 F5 或点击右上角「运行」运行游戏
    echo.
    echo 方式二：在 run_game.bat 里设置 GODOT_EXE
    echo   用记事本打开本文件，把 set GODOT_EXE= 改成：
    echo   set GODOT_EXE=C:\你的Godot安装路径\Godot_v4.x_win64.exe
    echo   保存后双击本文件即可运行游戏
    echo.
    pause
)
