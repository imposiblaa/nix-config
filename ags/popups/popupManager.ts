import { Variable } from "astal"
import { App } from "astal/gtk4"

const POPUP_NAMES = [
  "volume-popup",
  "network-popup",
  "bluetooth-popup",
  "battery-popup",
  "calendar-popup",
  "system-popup",
  "media-popup",
]

export const activePopup = Variable<string>("")

export function openPopup(name: string) {
  closeAllPopups(name)
  const win = App.get_window(name)
  if (win) {
    const nowVisible = !win.get_visible()
    win.set_visible(nowVisible)
    activePopup.set(nowVisible ? name : "")
  }
}

export function closeAllPopups(except?: string) {
  POPUP_NAMES.forEach(n => {
    if (n !== except) {
      App.get_window(n)?.set_visible(false)
    }
  })
  if (!except) {
    activePopup.set("")
  }
}
