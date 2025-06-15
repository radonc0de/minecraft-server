#!/bin/bash

show_help() {
  echo "Usage: $0 -n <server_name> -p <path_to_server_files> [--start]"
  echo
  echo "Arguments:"
  echo "  -n <server_name>         Name of the Minecraft server (required)"
  echo "  -p <path_to_server_files> Path where the server files will reside (required)"
  echo "  --start                  Optional flag to start the server immediately after setup"
  echo "  --dryrun                 Optional flag to run in dry run mode."
  echo
  echo "Example:"
  echo "  $0 -n MyServer -p /var/minecraft/MyServer --start"

}

while [[ $# -gt 0 ]]; do
  case "$1" in
  -n)
    SERVER_NAME="$2"
    shift 2
    ;;
  -p)
    SERVER_PATH="$2"
    shift 2
    ;;
  --start)
    START_SERVER=true
    shift
    ;;
  --dryrun)
    DRYRUN=true
    shift
    ;;
  -h | --help)
    show_help
    exit 0
    ;;
  *)
    echo "Unknown option: $1"
    show_help
    exit 1
    ;;
  esac
done

# Check required arguments
if [[ -z "$SERVER_NAME" || -z "$SERVER_PATH" ]]; then
  echo "Error: -n and -p arguments are required."
  show_help
  exit 1
fi

SYSDPATH="/etc/systemd/system"
#SYSDPATH="./test/system"
echo "Creating ./files/minecraft.service as $SYSDPATH/mc-$SERVER_NAME.service"
echo "Creating ./files/minecraft.timer as $SYSDPATH/mc-$SERVER_NAME.timer"
echo "Creating ./files/minecraft-backup.serivce as $SYSDPATH/mcbackup-$SERVER_NAME.service"
echo "Creating ./files/minecraft-backup.timer as $SYSDPATH/mcbackup-$SERVER_NAME.timer"

if [[ "$DRYRUN" == "true" ]]; then
  echo "These actions will be applied if running without --dryrun."
else
  #sed "s/[SERVER]/$SERVER_NAME/" ./files/minecraft.service >$SYSDPATH/mc-$SERVER_NAME.service
  #sed "s/[SERVER]/$SERVER_NAME/" ./files/minecraft.timer >$SYSDPATH/mc-$SERVER_NAME.timer
  #sed "s/[SERVER]/$SERVER_NAME/" ./files/minecraft-backup.service >$SYSDPATH/mcbackup-$SERVER_NAME.service
  #sed "s/[SERVER]/$SERVER_NAME/" ./files/minecraft-backup.timer >$SYSDPATH/mcbackup-$SERVER_NAME.timer
  ESCPATH=$(printf '%s\n' "$SERVER_PATH" | sed 's/[&/\]/\\&/g')
  sed -e "s/\[SERVER\]/$SERVER_NAME/g" -e "s/\[SERVER-PATH\]/$ESCPATH/g" ./files/minecraft.service >"$SYSDPATH/mc-$SERVER_NAME.service"
  sed -e "s/\[SERVER\]/$SERVER_NAME/g" -e "s/\[SERVER-PATH\]/$ESCPATH/g" ./files/minecraft.timer >"$SYSDPATH/mc-$SERVER_NAME.timer"
  sed -e "s/\[SERVER\]/$SERVER_NAME/g" -e "s/\[SERVER-PATH\]/$ESCPATH/g" ./files/minecraft-backup.service >"$SYSDPATH/mcbackup-$SERVER_NAME.service"
  sed -e "s/\[SERVER\]/$SERVER_NAME/g" -e "s/\[SERVER-PATH\]/$ESCPATH/g" ./files/minecraft-backup.timer >"$SYSDPATH/mcbackup-$SERVER_NAME.timer"
fi
