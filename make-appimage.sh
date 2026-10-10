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

# Bundle pika-backup-monitor: it is the scheduled-backups daemon. Without it
# the UI reports "The background process is inactive" (issue #1).
# quick-sharun auto-deploys the matching D-Bus service, but a D-Bus service
# alone is not enough: it must also be *started*. That is done by the custom
# hook in ./AppDir/bin/25-start-monitor.hook (already in place because
# quick-sharun builds into $PWD/AppDir).
quick-sharun /usr/bin/pika-backup \
             /usr/bin/pika-backup-monitor \
             /usr/bin/borg \
             /usr/lib/python*/site-packages/borg \
             /usr/bin/ssh

# Turn AppDir into AppImage
quick-sharun --make-appimage

# Test the app for 12 seconds; if it fails due to the app having issues
# running in the CI, use --simple-test instead
quick-sharun --test ./dist/*.AppImage
