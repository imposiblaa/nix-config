import { App, Astal, Gdk } from "astal/gtk4"
import style from "./style.scss"
import Bar from "./bar/Bar"
import VolumePopup from "./popups/VolumePopup"
import NetworkPopup from "./popups/NetworkPopup"
import BluetoothPopup from "./popups/BluetoothPopup"
import BatteryPopup from "./popups/BatteryPopup"
import CalendarPopup from "./popups/CalendarPopup"
import SystemPopup from "./popups/SystemPopup"
import MediaPopup from "./popups/MediaPopup"

App.start({
  css: style,
  main() {
    const bars = new Map<Gdk.Monitor, Astal.Window>()
    const display = Gdk.Display.get_default()!
    const monitors = display.get_monitors()

    // Create bars for all current monitors
    for (let i = 0; i < monitors.get_n_items(); i++) {
      const mon = monitors.get_item(i) as Gdk.Monitor
      bars.set(mon, Bar(mon))
    }

    // Listen for monitor changes
    monitors.connect("items-changed", (_list: any, position: number, removed: number, added: number) => {
      // Remove bars for disconnected monitors
      const currentMons = new Set<Gdk.Monitor>()
      for (let i = 0; i < monitors.get_n_items(); i++) {
        currentMons.add(monitors.get_item(i) as Gdk.Monitor)
      }

      for (const [mon, bar] of bars) {
        if (!currentMons.has(mon)) {
          bar.destroy()
          bars.delete(mon)
        }
      }

      // Add bars for new monitors
      for (const mon of currentMons) {
        if (!bars.has(mon)) {
          bars.set(mon, Bar(mon))
        }
      }
    })

    // Create popups (only need one set)
    VolumePopup()
    NetworkPopup()
    BluetoothPopup()
    BatteryPopup()
    CalendarPopup()
    SystemPopup()
    MediaPopup()
  },
})
