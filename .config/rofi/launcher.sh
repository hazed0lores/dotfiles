#!/usr/bin/env bash
rofi \
    -show drun \
    -theme launcher.rasi \
    -run-command "uwsm app -- {cmd}"
