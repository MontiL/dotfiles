#!/usr/bin/env fish

defaults read ~/Library/Preferences/com.apple.HIToolbox.plist AppleSelectedInputSources \
| grep '"KeyboardLayout Name" = ABC'
