#!/bin/sh

set -eu

ARCH=$(uname -m)
VERSION=$(pacman -Q pika-backup | awk '{print $2; exit}') # example command to get version of application here
export ARCH VERSION
export OUTPATH=./dist
export ADD_HOOKS="self-updater.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=/usr/share/icons/hicolor/scalable/apps/org.gnome.World.PikaBackup.svg
export DESKTOP=/usr/share/applications/org.gnome.World.PikaBackup.desktop
export STARTUPWMCLASS=org.gnome.World.PikaBackup
export DEPLOY_PYTHON=1

# BUNDLE pika-backup-monitor: it is the scheduled-backups daemon. Without it
# the UI reports "The background process is inactive" (issue #1). We rely on
# quick-sharun auto-deploying the matching D-Bus service; no custom hook.
quick-sharun /usr/bin/pika-backup \
             /usr/bin/pika-backup-monitor \
             /usr/bin/borg \
             /usr/lib/python*/site-packages/borg \
             /usr/bin/ssh

# Turn AppDir into AppImage
quick-sharun --make-appimage
