#!/bin/bash
#Script is starting
echo "=== Simple File organizer ==="
echo "\nDo you want to sort your Downloads directory into dedicated subdirectories?(write: yes)"

read CONFIRM
CONFIRM=$( tr '[:upper:]' '[:lower:]' <<< "$CONFIRM" )
CONFIRM=$( sed 's/^[[:space:]]*//; s/[[:space:]]*$//' <<<"$CONFIRM" )

if [[ "$CONFIRM" != "yes" ]]; then
    echo "Script is going to stop"
    exit 1
fi
USER=$(whoami)
HOME_PATH=/home/"$USER"
if [ -d "$HOME_PATH/Downloads" ]; then
FULL_PATH=( "$HOME_PATH"/Downloads/* ) 
    else
FULL_PATH=( "$HOME_PATH"/Pobrane/* )
fi
TEST_EMPTY=$( basename ${FULL_PATH[0]} )
if [ "$TEST_EMPTY" = "*" ]; then
    echo "Directory is empty"
    exit 1
fi

for FILE in "${FULL_PATH[@]}"
do
    if [[ "$FILE" = *.* ]]; then
    FILE_NAME=$( basename "$FILE" )
    EXT_NAME=${FILE##*.}
    EXT_NAME=$( tr '[:lower:]' '[:upper:]' <<< "$EXT_NAME" ) 
    if [ -d "$HOME_PATH/$EXT_NAME" ]; then
    mv "$FILE" "$HOME_PATH/$EXT_NAME/"
    else
    mkdir -p "$HOME_PATH/$EXT_NAME"
    mv "$FILE" "$HOME_PATH/$EXT_NAME/"
    echo "File will be moved $FILE_NAME to $HOME_PATH/$EXT_NAME"
    fi
    else
    FILE_NAME=$( basename "$FILE" )
    echo "This file $FILE_NAME doesn't has an extension,moving to $HOME_PATH/NOEXT"
    mkdir -p "$HOME_PATH/NOEXT"
    mv "$FILE" "$HOME_PATH/NOEXT/"
    fi
done    

echo "=== End of the script work ==="