@echo off
echo ==========================================
echo    职教通 (Vocational Bridge) 后端启动脚本
echo ==========================================
echo.
echo 正在检查 Node.js 环境...
node -v >nul 2>&1
if %errorlevel% neq 0 (
    echo [错误] 请先安装 Node.js!
    pause
    exit /b
)

echo 正在安装依赖 (npm install)...
call npm install

echo 正在编译 TypeScript (npm run build)...
call npm run build

echo.
echo ------------------------------------------
echo    后端服务即将运行在 http://localhost:3000
echo    教师端看板: http://localhost:3000/teacher/C001
echo    运营看板: http://localhost:3000/boss
echo ------------------------------------------
echo.

npm start
pause
