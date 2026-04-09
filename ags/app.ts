import { App } from "astal/gtk4"
import style from "./style.scss"
import Bar from "./bar/Bar"
import VolumePopup from "./popups/VolumePopup"
import NetworkPopup from "./popups/NetworkPopup"
import BluetoothPopup from "./popups/BluetoothPopup"
import BatteryPopup from "./popups/BatteryPopup"
import CalendarPopup from "./popups/CalendarPopup"
import SystemPopup from "./popups/SystemPopup"
import WeatherPopup from "./popups/WeatherPopup"

App.start({
  css: style,
  main() {
    App.get_monitors().map(Bar)
    VolumePopup()
    NetworkPopup()
    BluetoothPopup()
    BatteryPopup()
    CalendarPopup()
    SystemPopup()
    WeatherPopup()
  },
})
