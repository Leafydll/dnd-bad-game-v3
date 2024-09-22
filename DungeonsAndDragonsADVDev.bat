@echo off
setlocal enabledelayedexpansion

:StartPrompt
echo Press Enter to start the game...
set /p dummy=""

:MainMenu
echo Welcome to the D&D Adventure!
echo Developer: Leafii
echo Dedication: Unkva
echo.

:CharacterSelection
echo Please choose your character class:
echo 1. Tech
echo 2. Explorer
echo 3. Excited
echo 4. DevLogIn
set /p classChoice="Choose your class (1-4): "

if "%classChoice%"=="1" (set class=Tech & set /a health=90 & set /a attackPower=20)
if "%classChoice%"=="2" (set class=Explorer & set /a health=100 & set /a attackPower=15)
if "%classChoice%"=="3" (set class=Excited & set /a health=80 & set /a attackPower=25)
if "%classChoice%"=="4" (
    call :DevLogIn
    if defined devMode (
        goto GameMode
    ) else (
        goto CharacterSelection
    )
)

:GameMode
echo You have chosen: !class!
echo Choose game mode:
echo 1. Violent
echo 2. Non-Violent
set /p modeChoice="Choose your mode (1 or 2): "

if "%modeChoice%"=="1" (set mode=Violent) else (set mode=Non-Violent)

set experience=0
set godMode=false
set examining=false
set currentObject=

:Quest
echo.
echo You can:
echo 1. Explore Forest
echo 2. Enter Cave
echo 3. Check Commands
set /p choice="Choose your action (1-3): "

if "%choice%"=="1" (call :ExploreForest)
if "%choice%"=="2" (call :EnterCave)
if "%choice%"=="3" (call :ShowCommands)

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

:ShowCommands
echo Available Commands:
echo /find {food} [Meat]
echo /look {toandfrom} [at] \object\
echo /look {away} [from] \object\
echo /look {at} [object]
echo /look {browse} [quests]\
echo /GodModeEnable (Developer Only)
echo /GodModeDisable (Developer Only)
goto Quest

:EnemyEncounter
echo A goblin appears! Health: 30
set /a enemyHealth=30

:Combat
if defined godMode (
    echo You are in God Mode! Instakill activated!
    set /a damage=30
) else (
    if defined devMode (
        echo You are in Developer Mode. You deal 100 damage per attack!
        set /a damage=100
    ) else (
        set /a damage=!random! %% !attackPower! + 1
    )
)

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

:DevLogIn
set /p devCode="Enter developer code: "
if "%devCode%"=="43526" (
    echo Access Granted. You are now in Developer Mode.
    set devMode=true
    goto GameMode
) else (
    echo Access Denied. Returning to main menu.
)
goto CharacterSelection

:Look
set /p lookCommand="Enter command: "
if "!lookCommand!"=="{toandfrom} [at] \object\" (
    set examining=true
    set currentObject=object
    echo Examining the object...
) else if "!lookCommand!"=="{away} [from] \object\" (
    set examining=false
    echo You stop examining the object.
) else if "!lookCommand!"=="{at} [object]" (
    echo You see a beautiful object with intricate designs. (Displayed in blue)
) else if "!lookCommand!"=="{browse} [quests]\" (
    echo You have the following quests in progress: 
    echo - Find the ancient artifact
    echo - Defeat the goblin king
) else (
    echo Invalid look command.
)
goto Quest
