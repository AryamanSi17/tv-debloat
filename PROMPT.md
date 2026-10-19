# The prompt

**First, on the TV:** Settings → System → About → press OK on **Build** 7 times → back → Developer
options → turn on **USB debugging**. Keep the TV on and on the same Wi-Fi as your computer.

Then run Claude Code inside this repo and paste (Android TV / Google TV only, not Samsung, LG or Fire TV):

```text
My Android TV is slow and full of ads. Use the tools in this repo to find it on my Wi-Fi, connect
over ADB, and snapshot it with tools/backup.sh before changing anything. Then debloat it: disable
the manufacturer's ads, telemetry and junk with tools/disable.sh (reversibly, never uninstall),
asking me first about apps and features I might use, and save the list under examples/<my TV model>/.
Don't install anything on the TV and never disable the home screen app. Check every step with
screenshots from the TV, test that Home and my apps still work, and tell me how to roll back.

Note: tools/tv.py talks ADB without the adb binary (macOS blocks it).
```

Afterwards, `tools/remote.sh` drives the TV from your keyboard.
