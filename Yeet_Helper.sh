#!/bin/sh

#By XDM
GAME_EXE="VotV.exe"
PATCH_DIR="YeetPatch"
PATCH_SCRIPT="$PATCH_DIR/YeetPatch.sh"

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
GAME_PATH="$SCRIPT_DIR/$GAME_EXE"
PATCH_PATH="$SCRIPT_DIR/$PATCH_SCRIPT"


command -v zenity >/dev/null 2>&1 || { echo "Zenity is required."; exit 1; }
command -v wine >/dev/null 2>&1 || { zenity --error --text="Wine is required."; exit 1; }


error() { zenity --error --text="$1"; }
info() { zenity --info --text="$1"; }


[ ! -f "$GAME_PATH" ] && { error "VotV.exe not found."; exit 1; }


while true; do
    CHOICE=$(zenity --list \
        --title="Voices of the Void" \
        --text="Select an action:" \
        --column="Action" \
        "Launch Game" \
        "Launch Game (Vulkan EXPERIMENTAL)" \
        "Check/Update Game" \
        "Set up / Config YeetPatch" \
        "Exit")

    [ -z "$CHOICE" ] && exit 0

    case "$CHOICE" in

    "Launch Game")
        wine "$GAME_PATH"
        exit 0
        ;;

    "Launch Game (Vulkan EXPERIMENTAL)")
        wine "$GAME_PATH" -vulkan
        exit 0
        ;;

    "Set up / Config YeetPatch")
        [ ! -f "$PATCH_PATH" ] && { error "YeetPatch.sh not found."; continue; }

        EXE_SELECTED=$(zenity --file-selection \
            --title="Select VotV.exe" \
            --file-filter="VotV.exe")
        [ -z "$EXE_SELECTED" ] && continue
        sed -i "s|^EXE_PATH=.*|EXE_PATH=\"$EXE_SELECTED\"|" "$PATCH_PATH"

        INSTALL_SELECTED=$(zenity --file-selection \
            --directory \
            --title="Select install directory (windowsnoeditor folder)")
        [ -z "$INSTALL_SELECTED" ] && continue
        sed -i "s|^INSTALL_DIR=.*|INSTALL_DIR=\"$INSTALL_SELECTED\"|" "$PATCH_PATH"

        info "YeetPatch configured successfully."
        ;;

    "Check/Update Game")
        [ ! -f "$PATCH_PATH" ] && { error "YeetPatch.sh not found."; continue; }
        chmod +x "$PATCH_PATH"

        TMP_OUTPUT=$(mktemp)


        "$PATCH_PATH" update 2>&1 | tee "$TMP_OUTPUT" | \
            zenity --text-info \
                --title="YeetPatch Output" \
                --width=750 \
                --height=500 \
                --auto-scroll

        STATUS=${PIPESTATUS:-0}

        if [ "$STATUS" -ne 0 ]; then
            error "Update failed. See output."
            rm -f "$TMP_OUTPUT"
            continue
        fi


        if grep -q "Already at latest" "$TMP_OUTPUT"; then
            VERSION=$(sed -n 's/.*Already at latest (\(.*\)).*/\1/p' "$TMP_OUTPUT")


            if ! ls "$SCRIPT_DIR"/Version_* >/dev/null 2>&1; then
                touch "$SCRIPT_DIR/Version_$VERSION"
            fi

            info "Already up-to-date.\nVersion: $VERSION"
            rm -f "$TMP_OUTPUT"
            continue
        fi


        VERSION=$(grep -o '[0-9]\+\.[0-9]\+\.[0-9a-zA-Z_]\+' "$TMP_OUTPUT" | tail -n1)


        rm -f "$SCRIPT_DIR"/Version_*
        [ -n "$VERSION" ] && touch "$SCRIPT_DIR/Version_$VERSION"

        info "Update complete.\nInstalled version: $VERSION"
        rm -f "$TMP_OUTPUT"
        ;;

    "Exit")
        exit 0
        ;;
    esac
done
