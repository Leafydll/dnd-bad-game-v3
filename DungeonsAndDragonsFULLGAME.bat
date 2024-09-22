@echo off
setlocal enabledelayedexpansion

:: Initialize log file
set logFile=game_log.txt
echo Game Log > %logFile%
echo ==================== >> %logFile%

:: Initialize gamelogs file
set gameLogs=gamelogs.txt
echo Game Logs >> %gameLogs%
echo ==================== >> %gameLogs%

:: Initialize inventory and player data
set inventory=
set username=
set ability=
set playerHealth=100
set enemyHealth=50
set devMode=false

:StartPrompt
echo Press Enter to start the game...
set /p dummy=""

:MainMenu
echo Welcome to the D^&D adventure!
echo Developer: Leafii
echo Dedication: Unkva
echo.
set /p username="Please enter your username: "
set /p confirmUser="Are you sure that's your name? (Y/N): "
if /i "%confirmUser%" NEQ "Y" (
    echo Ok, Choose another name!
    goto MainMenu
)
echo Nice name! %username%! 

:: Log the username
echo %date% %time%: Username set to %username% >> %gameLogs%

:SelectAbility
echo Please enter your ability so we can find enemies that fit for you.
echo Abilities available:
echo 1. Electricity - Control electricity.
echo 2. Water - Use nearby water to attack and walk on water.
echo 3. Fire - Control fire.
echo 4. Air - Go invisible and manipulate air.
echo 5. Earth - Control the ground and natural elements.
echo 6. Cloud - Fly and engage flying enemies.
set /p abilityChoice="Choose your ability (1-6): "

rem Input validation
if "%abilityChoice%"=="1" (set ability=Electricity)
if "%abilityChoice%"=="2" (set ability=Water)
if "%abilityChoice%"=="3" (set ability=Fire)
if "%abilityChoice%"=="4" (set ability=Air)
if "%abilityChoice%"=="5" (set ability=Earth)
if "%abilityChoice%"=="6" (set ability=Cloud)

rem Check for invalid input
if not defined ability (
    echo Invalid choice! Please select a valid ability.
    goto SelectAbility
)

set /p confirmAbility="Are you sure that's your ability? (Y/N): "
if /i "%confirmAbility%"=="Y" (
    echo Alright! Your ability is now %ability%.
) else (
    echo Choose another!
    goto SelectAbility
)

:: Log the ability
echo %date% %time%: Ability set to %ability% >> %gameLogs%
echo.

:Quest
:MainQuestMenu
echo You can:
echo 1. Explore Forest
echo 2. Enter Cave
echo 3. Check Inventory
echo 4. Use Commands
echo 5. Developer Login
echo 6. View Logs
echo 7. Restart Game (Type 'restart' to restart)
echo 8. Exit
set /p questChoice="Choose your action (1-8): "

if /i "%questChoice%"=="restart" (
    call :RestartGame
)

if "%questChoice%"=="1" (call :ExploreForest)
if "%questChoice%"=="2" (call :EnterCave)
if "%questChoice%"=="3" (call :CheckInventory)
if "%questChoice%"=="4" (call :UseCommands)
if "%questChoice%"=="5" (call :DevLogIn)
if "%questChoice%"=="6" (call :ViewLogs)
if "%questChoice%"=="7" exit /b

goto MainQuestMenu

:ExploreForest
echo You venture into the forest...
:: Log the action
echo %date% %time%: Explored the forest >> %gameLogs%
:: Simulate some forest encounter
call :PlayerAction
goto MainQuestMenu

:EnterCave
echo You enter the cave...
:: Log the action
echo %date% %time%: Entered the cave >> %gameLogs%
:: Simulate some cave encounter
call :PlayerAction
goto MainQuestMenu

:PlayerAction
echo.
echo You encounter an enemy!
echo Enemy Health: !enemyHealth!
echo Your Health: !playerHealth!
call :BattleMenu
goto MainQuestMenu

:BattleMenu
echo.
echo It's your turn! Choose your action:
echo 1. /attack <enemy> - Attack the enemy.
echo 2. /defend <parry> - Parry an attack.
echo 3. /mercy <beg for mercy> - Request mercy from the enemy.
set /p choice="Choose your action (1-3): "

if "%choice%"=="1" (call :Attack)
if "%choice%"=="2" (call :Defend)
if "%choice%"=="3" (call :Mercy)

:: Enemy attacks after player's turn
set /a damageTaken=10
set /a playerHealth-=damageTaken
echo The enemy attacks! You take !damageTaken! damage.
echo Your Health: !playerHealth!

if !playerHealth! LEQ 0 (
    echo You have been defeated!
    echo %date% %time%: Defeated by enemy >> %gameLogs%
    exit /b
)

goto MainQuestMenu

:Attack
set /p target="Who do you want to attack? "
echo You attack %target%! 
:: Log the action
echo %date% %time%: Attacked %target% >> %gameLogs%
goto :eof

:Defend
set /p defendChoice="What do you want to parry? "
echo You defend against %defendChoice%!
:: Log the action
echo %date% %time%: Defended against %defendChoice% >> %gameLogs%
goto :eof

:Mercy
echo You beg for mercy!
set /a chance=!random! %% 2
if !chance! == 0 (
    echo The enemy lets you go! You are safe for now.
    echo %date% %time%: Begged for mercy and was let go >> %gameLogs%
) else (
    echo The enemy is not in a forgiving mood and attacks you!
    set /a damageTaken=15
    set /a playerHealth-=damageTaken
    echo You take !damageTaken! damage. Your Health: !playerHealth!
    echo %date% %time%: Begged for mercy but was attacked >> %gameLogs%
)

if !playerHealth! LEQ 0 (
    echo You have been defeated!
    echo %date% %time%: Defeated by enemy after begging for mercy >> %gameLogs%
    exit /b
)

goto :eof

:CheckInventory
echo Your inventory contains:
if "!inventory!"=="" (
    echo (Empty)
) else (
    echo !inventory!
)
goto :eof

:UseCommands
echo You can:
echo 1. /attack <enemy>
echo 2. /defend <parry>
echo 3. /mercy <beg for mercy>
echo 4. /find {category} [item in category] <amount>
echo 5. /rest <gain health>
echo 6. /sleep <dream>
echo 7. /gainxp <num of xp> (DEVELOPER MODE ONLY)
echo 8. /godmode
echo 9. /logs - View your game logs.
echo 10. Help
echo 11. Exit
set /p commandChoice="Choose a command: "

:: Handle commands here based on input
if "%commandChoice%"=="/logs" (call :ViewLogs)

goto :eof

:ViewLogs
echo Game Logs:
if exist "%gameLogs%" (
    type "%gameLogs%"
) else (
    echo No logs found.
)
goto :eof

:RestartGame
echo Restarting the game...
call "%~f0"  :: Calls the current script file to restart
exit /b

:DevLogIn
set /p devCode="Enter developer code: "
if "%devCode%"=="43526" (
    echo Access Granted. You are now in Developer Mode.
    set devMode=true
) else (
    echo Access Denied.
)
goto :eof
