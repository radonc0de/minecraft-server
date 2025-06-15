# minecraft-server

- Leverages systemd for auto-starting minecraft server, as well as intelligent S3 backups to the cloud

## Prerequisites
- 

## Usage
Usage: `sudo ./install.sh -n MyServer -p /home/minecraft/MyServer`
  - n      : Name of server
  - p      : Path to server files, this expects a `start.sh` in this location that actually starts the server
  --dryrun : Shows which files will get deployed with the given options and where
  --start  : Starts server immediately after deploying files

## Backups
