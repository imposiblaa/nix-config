# My NixOS Configs

A collection to system and home configurations which I run on my personal laptop. Not positive these follow best practices, maybe I'll improve that later. Currently a pretty minimal setup but I plan on making this daily-drivable in the future.

## TODO
----------------------------------
### Visual Improvements (all related to AGS)
- [ ] Popups look bland, add more detailing I guess. Definitely include more accent colors in the popups themselves
- [ ] Fix weirdly off-center calendar
- [ ] Make too-long text in the pill readout scroll by like on a bus stop readout
- [ ] Combine CPU and RAM pills
----------------------------------
### Functional Improvements
- [ ] Handle monitor disconnects/reconnects (bar doubles itself when monitor disconnects and displays aren't positioned properly after reconnect)
- [ ] AGS Hover goes away after clicking an icon and then icon cannot be clicked again until the mouse moves (should be able to spam click to open and close the popup)
- [ ] Clicking anywhere off the popup should close it
- [ ] Include ethernet info in the network popup
- [ ] Include system tray somewhere on the bar (but hide it because it's ugly)
- [ ] Address split-workspace errors which appear for half a second whenever hyprland first opens (I guess the addon isn't loading at the start?). I was thinking it is possible this could be fixed with a proper display manager besides ly (since it will load the graphical environment before actually entering it) but who knows.
- [ ] Completely remove media readout from middle of bar
- [ ] Completely delete weather popup and replace with media popup (play, pause, skip, thumbnail(?), title, artist(?), pill summary of title, etc.
- [ ] Fix empty uptime readout
- [ ] Add clock to calendar popup (seconds included)
