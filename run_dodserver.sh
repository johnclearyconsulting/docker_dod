#!/bin/bash

# Created by: john Cleary (john@cleary.com.au)
# Last updated @ 12h27m on 2020-05-07
# Script to launch Day of Defeat Source server

# Built on top of: https://github.com/LacledesLAN/gamesvr-dods

# This script should be run on a machine that already has Docker (i.e. Linode Docker App Instance)

# To Install / Run:
# nano run_dodserver.sh
# paste in script
# chmod +x run_dodserver.sh
# ./run_dodserver.sh

# Install / Update Docker Container
echo "Do you want to install or check for updates to the Day of Defeat docker container? (type 'Y' to do so)"
read refresh_docker

if [ "$refresh_docker" == "Y" ]; then
	# Install / Update container with:
	docker pull lacledeslan/gamesvr-dods;
fi

# Choose Map from defaults installed with container.
echo "What map do you want to start?"
echo "+----------------+"
echo "| Available Maps |"
echo "+----------------+"
echo "dod_anzio"
echo "dod_argentan"
echo "dod_avalanche"
echo "dod_colmar"
echo "dod_donner"
echo "dod_flash"
echo "dod_jagd"
echo "dod_kalt"
echo "dod_palermo"
echo ""
echo "Please enter preferred map, or hit return for random:"

read map_to_launch

if [ -z "$map_to_launch" ]; then
	echo "No map chosen. Selecting random map now."
	maps=("dod_anzio" "dod_argentan" "dod_avalanche" "dod_colmar" "dod_donner" "dod_flash" "dod_jagd" "dod_kalt" "dod_palermo")
	map_to_launch=${maps[$RANDOM % ${#maps[@]} ]}
	echo "Selected map is: $map_to_launch"
else
	echo "Selected map is: $map_to_launch"
fi

echo "Enter Server Name:"
read server_displayname
if [ -z "$server_displayname" ]; then
	echo "No server display name entered, which is required. Exiting script."
	exit
fi

echo "Enter Remote Console connection password, or hit return for none:"
read rcon_password

echo "Enter server player connection password, or hit return for none:"
read server_password

# Launch server now
echo "Starting server now with map: $map_to_launch"
docker run -it --rm --net=host lacledeslan/gamesvr-dods ./srcds_run -game dod +map $map_to_launch +sv_lan 0 +hostname $server_displayname +rcon_password $rcon_password +sv_password $server_password
