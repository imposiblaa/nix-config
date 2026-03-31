import { App } from "astal/gtk4"

const POPUP_NAMES = [
  "volume-popup",
  "network-popup",
  "bluetooth-popup",
  "calendar-popup",
  "system-popup",
  "weather-popup",
  "tray-popup",
]

export function openPopup(name: string) {
  // Close all other popups first
  POPUP_NAMES.forEach(n => {
    if (n !== name) {
      App.get_window(n)?.set_visible(false)
    }
  })
  // Toggle the requested popup
  const win = App.get_window(name)
  if (win) win.set_visible(!win.get_visible())
}

export function closeAllPopups() {
  POPUP_NAMES.forEach(n => {
    App.get_window(n)?.set_visible(false)
  })
}
