#!/bin/bash
#Script is starting
echo "=== File organizer ==="
echo "\nDo you want to sort your Downloads directory into dedicated subdirectories?(write: yes)"

read CONFIRM
CONFIRM=$( tr '[:upper:]' '[:lower:]' <<< "$CONFIRM" )
CONFIRM=$( sed 's/^[[:space:]]*//; s/[[:space:]]*$//' <<<"$CONFIRM" )

if [[ "$CONFIRM" != "yes" ]]; then
    echo "Script is going to stop"
    exit 1
fi

USER=$(whoami)

HOME_LIST=( /home/"$USER"/* )
#WORKS ONLY FOR POLISH AND ENGLISH 
DOWNLOADS_FOLDER=$( grep "Downloads" <<< "${HOME_LIST[@]}" )
if [[ "$DOWNLOADS_FOLDER" = "" ]]; then
DOWNLOADS_FOLDER=$( grep "Pobrane" <<< "${HOME_LIST[@]}" )
fi
FULL_PATH=( /home/"$USER"/"$DOWNLOADS_FOLDER"/* ) 

for FILE in $FULL_PATH
    do
    DIR_EXTEN="${FILE##*.}"
    DIR_EXTEN=$(tr '[:lower:]' '[:upper:]' <<< "$DIR_EXTEN" )
    FILE_NAME="${FILE%.*}"
    DIR_CHECK=$( grep "$DIR_EXTEN" <<< "$HOME_LIST")
    if ( DIR_CHECK = ""); then
        mkdir "$/home/"$USER"/$DIR_EXTEN"
    fi
    echo "Moving $FILE_NAME to $DIR_EXTEN"
    mv "$FILE" "/$HOME_LIST/$DIR_EXTEN/$FILE_NAME.$DIR_EXTEN" 
    done
echo "=== End of the script work ==="