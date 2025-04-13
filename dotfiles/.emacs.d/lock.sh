#!/bin/bash
cd /home/gator/others/emacs && lib-src/emacsclient -s /run/user/1000/emacs/server --eval "(lock)"
