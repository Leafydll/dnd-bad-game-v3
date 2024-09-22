@echo off
setlocal enabledelayedexpansion

:: Initialize log file
set logFile=game_log.txt
echo Game Log > %logFile%
echo ==================== >> %logFile%

:StartPrompt
echo Press Enter to start the game...
set /p dummy=""

:MainMenu
echo Welcome to the D&D Adventure!
echo Developer: Leafii
echo Dedication: Unkva
echo.
echo 1. Create Account
echo 2. Load Account
echo 3. Start Game (No Account)
echo 4. Exit
set /p menuChoice="Choose an option (1-4): "

if "%menuChoice%"=="1" (call :CreateAccount)
if "%menuChoice%"=="2" (call :LoadAccount)
if "%menuChoice%"=="3" (call :StartGame)
if "%menuChoice%"=="4" exit /b

goto MainMenu

:CreateAccount
set /p username="Enter a username: "

:: Check for restricted usernames
if /i "%username%"=="Unkva" (
    set /p devCode="You got the game Unkva! Enter the dev code below: "
    if "%devCode%" NEQ "43526" (
        echo Access Denied. Cannot create account with that name.
        goto MainMenu
    )
)

if /i "%username%"=="DavHed" (
    set /p devCode="You got the game DavHed! Enter the dev code below: "
    if "%devCode%" NEQ "43526" (
        echo Access Denied. Cannot create account with that name.
        goto MainMenu
    )
)

set /p password="Enter a password: "
echo Username: %username%, Password: %password% > "%username%_account.txt"
echo Account created successfully!

:: Check if the username is "Leafii"
if /i "%username%"=="Leafii" (
    echo Woah! Unexpected. Are you a developer?
    call :DevLogIn
)

goto MainMenu

:LoadAccount
set /p username="Enter your username: "
set /p password="Enter your password: "

:: Check if account file exists
if not exist "%username%_account.txt" (
    echo Account does not exist!
    set /p reset="Forgot your password? Type 'reset' to reset it, or anything else to return to main menu: "
    if /i "%reset%"=="reset" (
        call :ResetPassword
    ) else (
        goto MainMenu
    )
)

:: Verify password
for /f "tokens=2,3 delims=," %%a in ('type "%username%_account.txt"') do (
    if "%%b"=="%password%" (
        echo Password verified. Loading game...
        echo 1. Start Game
        echo 2. Return to Main Menu
        set /p gameChoice="Choose an option (1-2): "
        if "%gameChoice%"=="1" (goto GameInitWithAccount)
        if "%gameChoice%"=="2" (goto MainMenu)
    )
)

echo Incorrect password. Returning to main menu.
goto MainMenu

:StartGame
echo You have chosen to start the game without an account.
set /p rewardCode="Enter code for a reward (or leave blank to skip): "

if "%rewardCode%"=="JoinedFromD&DDiscord" (
    echo Reward unlocked! Your code is: 53215
) else (
    echo No reward applied.
)

goto GameInit

:GameInit
echo You are starting the game.
set class=
set health=100
set experience=0
set godMode=false
set examining=false
set currentObject=
set aiClass=Explorer
set aiHealth=100
set aiExperience=0

:CharacterSelection
echo Please choose your character class:
echo 1. Tech
echo 2. Explorer
echo 3. Excited
set /p classChoice="Choose your class (1-3): "

if "%classChoice%"=="1" (set class=Tech & set /a health=90 & set /a attackPower=20)
if "%classChoice%"=="2" (set class=Explorer & set /a health=100 & set /a attackPower=15)
if "%classChoice%"=="3" (set class=Excited & set /a health=80 & set /a attackPower=25)

:Quest
echo.
echo You are starting the game with your AI companion!
echo Your companion is an AI class: !aiClass!
echo You can:
echo 1. Explore Forest
echo 2. Enter Cave
echo 3. Use Commands
echo 4. Save Game
echo 5. Return to Main Menu
set /p choice="Choose your action (1-5): "

if "%choice%"=="1" (call :ExploreForest)
if "%choice%"=="2" (call :EnterCave)
if "%choice%"=="3" (call :UseCommands)
if "%choice%"=="4" (call :SaveGame)
if "%choice%"=="5" (goto MainMenu)

goto Quest

:ExploreForest
echo You venture into the forest...
:: Player Action
call :PlayerAction
:: AI Action
call :AIAction
goto Quest

:EnterCave
echo You enter the cave...
:: Player Action
call :PlayerAction
:: AI Action
call :AIAction
goto Quest

:PlayerAction
set /p playerChoice="Choose your action (1: Attack, 2: Defend, 3: Search): "
if "%playerChoice%"=="1" (
    echo You attack the enemy!
    set /a damage=attackPower
    echo You dealt !damage! damage!
) else if "%playerChoice%"=="2" (
    echo You defend yourself!
) else if "%playerChoice%"=="3" (
    echo You search the area and find some treasure!
    set /a experience+=50
) else (
    echo Invalid action. Your turn is skipped.
)

goto :eof

:AIAction
echo Now, it's the AI's turn!
set /a aiAction=!random! %% 3 + 1
if "!aiAction!"=="1" (
    echo Your AI companion attacks the enemy!
    set /a aiDamage=15
    echo The AI dealt !aiDamage! damage!
) else if "!aiAction!"=="2" (
    echo Your AI companion defends itself!
) else if "!aiAction!"=="3" (
    echo Your AI companion searches the area and finds some health potions!
    set /a aiExperience+=50
)

goto :eof

:UseCommands
set /p commandInput="Command Input: "
call :ProcessCommand "!commandInput!"
goto Quest

:SaveGame
echo Saving game data...
set playerData=class=!class! health=!health! experience=!experience! godMode=!godMode!
echo !playerData! > "%username%_data.txt"
echo Game saved successfully!
goto Quest

:DevLogIn
set /p devCode="Enter developer code: "
if "%devCode%"=="43526" (
    echo Access Granted. You are now in Developer Mode.
    set devMode=true
    goto CharacterSelection
) else (
    echo Access Denied.
)
goto CharacterSelection
