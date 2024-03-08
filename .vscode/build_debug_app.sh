#!/bin/sh
set -eu

sh ./gradlew assembleDebug
cp app/build/outputs/apk/debug/app-debug.apk /sdcard
