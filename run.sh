#!/bin/bash

THIS_DIR=$(cd $(dirname $0); pwd)
cd $THIS_DIR

COUNTER=0

  while [ $COUNTER -lt 5 ]; do

       tmux kill-session -t script

           tmux new-session -s script "./telegram-cli -s tgGuard.lua"

        tmux detach -s script

    sleep 1

  done
