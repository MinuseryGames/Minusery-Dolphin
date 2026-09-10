#!/bin/sh

echo "Setup Discord rich presence"
for i in {0..9}; do
    test -S $XDG_RUNTIME_DIR/discord-ipc-$i ||
    ln -sf {app/com.discordapp.Discord,$XDG_RUNTIME_DIR}/discord-ipc-$i;
done

echo "Make directory /var/data/brawl-minus-dolphin/user/Wii if it doesn't exist"
mkdir -p /var/data/brawl-minus-dolphin/Wii

echo "Make directory /var/config/brawl-minus-dolphin if it doesn't exist"
mkdir -p /var/config/brawl-minus-dolphin

# Create and set variables for the system and user SD card creation dates
# SystemSDCardCreationDate=`stat --format="%W" /app/share/brawl-minus-dolphin/sys/Load/WiiSD.raw`
# UserSDCardCreationDate=`stat --format="%W" /var/data/brawl-minus-dolphin/Load/WiiSD.raw`

# echo "Check if there is a newer SD card version"
# if [ $SystemSDCardCreationDate -gt ${UserSDCardCreationDate:=0} ];
# then
#     echo "Make directory /var/data/brawl-minus-dolphin/Load if it doesn't exist"
#     mkdir -p /var/data/brawl-minus-dolphin/Load

#     echo "Copy newer SD card to user data directory"
#     cp /app/share/brawl-minus-dolphin/sys/Load/WiiSD.raw /var/data/brawl-minus-dolphin/Load/WiiSD.raw
# else
#     echo "SD card is already at latest version"
# fi

echo "Copy dol files to user data directory if they don't already exist"
cp -nr /app/share/brawl-minus-dolphin/sys/Wii/Launcher /var/data/brawl-minus-dolphin/user/Wii/

echo "Copy user directory to Flatpak user data directory (Overwritting any files already there with any newer files)"
cp -ru /app/share/brawl-minus-dolphin/user /var/data/brawl-minus-dolphin/

# Create and set variables for the system and user HD textures creation dates
SystemHDTexturesCreationDate=`stat --format="%W" /app/share/brawl-minus-dolphin/sys/Load/Textures/RSBE01`
UserHDTexturesCreationDate=`stat --format="%W" /var/data/brawl-minus-dolphin/user/Load/Textures/RSBE01`

echo "Check if there are newer HD textures"
if [ $SystemHDTexturesCreationDate -gt ${UserHDTexturesCreationDate:=0} ];
then
    echo "Make directory /var/data/brawl-minus-dolphin/user/Load/Textures if it doesn't exist"
    mkdir -p /var/data/brawl-minus-dolphin/Load/Textures

    echo "Copy newer HD textures to user data directory"
    cp -r /app/share/brawl-minus-dolphin/sys/Load/Textures/RSBE01 /var/data/brawl-minus-dolphin/user/Load/Textures
else
    echo "HD textures are already at latest version"
fi

# Launch Dolphin and point it to the user directory
brawl-minus-dolphin -u /var/data/brawl-minus-dolphin/user "$@"
