@echo off
setlocal enabledelayedexpansion

:MainMenu
echo Welcome to the D&D Adventure!
echo Developer: Leafii
echo Dedication: Unkva
echo.
echo Please choose your character class:
echo 1. Tech
echo 2. Explorer
echo 3. Excited
set /p classChoice="Choose your class (1-3): "
if "%classChoice%"=="1" (set class=Tech & set /a health=90 & set /a attackPower=20)
if "%classChoice%"=="2" (set class=Explorer & set /a health=100 & set /a attackPower=15)
if "%classChoice%"=="3" (set class=Excited & set /a health=80 & set /a attackPower=25)

:GameMode
echo You have chosen: !class!
echo Choose game mode:
echo 1. Violent
echo 2. Non-Violent
echo 3. DevLogIn
set /p modeChoice="Choose your mode (1, 2 or 3): "

if "%modeChoice%"=="1" (set mode=Violent) else if "%modeChoice%"=="2" (set mode=Non-Violent) else if "%modeChoice%"=="3" (
    call :DevLogIn
)

set experience=0
set inventory=

:Quest
echo.
echo You can:
echo 1. Explore Forest
echo 2. Enter Cave
echo 3. Check Inventory
set /p choice="Choose your action (1-3): "

if "%choice%"=="1" (call :ExploreForest)
if "%choice%"=="2" (call :EnterCave)
if "%choice%"=="3" (call :CheckInventory)

goto Quest

:ExploreForest
echo You venture into the forest...
set /a encounter=!random! %% 2
if !encounter! == 0 (
    call :EnemyEncounter
) else (
    echo You found some treasure!
    set /a experience+=50
    echo Gained 50 experience points!
)

goto Quest

:EnterCave
echo You enter the cave...
set /a encounter=!random! %% 2
if !encounter! == 0 (
    echo You found a magical artifact!
    set /a experience+=100
    echo Gained 100 experience points!
) else (
    call :EnemyEncounter
)

goto Quest

:CheckInventory
echo Your Inventory:
if defined inventory (
    echo !inventory!
) else (
    echo Your inventory is empty.
)
goto Quest

:EnemyEncounter
echo A goblin appears! Health: 30
set /a enemyHealth=30

:Combat
set /p action="Attack or Escape? (A/E): "
if /i "!action!"=="A" (
    set /a damage=!random! %% 10 + 1
    set /a enemyHealth-=damage
    echo You deal !damage! damage. Goblin Health: !enemyHealth!
    if !enemyHealth! LEQ 0 (
        echo You defeated the goblin!
        set /a experience+=50
        goto Quest
    )
    set /a goblinDamage=!random! %% 10 + 1
    echo Goblin attacks! You take !goblinDamage! damage.
    set /a health-=goblinDamage
    if !health! LEQ 0 (
        echo You have perished. Game Over.
        exit /b
    )
    goto Combat
) else (
    echo You escaped!
)

goto Quest

:DevLogIn
set /p devCode="Enter developer code: "
if "%devCode%"=="43526" (
    echo Access Granted. You are now in Developer Mode.
    rem Add developer features here in the future
    pause
) else (
    echo Access Denied. Returning to main menu.
)
goto MainMenu
