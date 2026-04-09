import { Variable } from "astal"
import { Gtk } from "astal/gtk4"
import { execAsync } from "astal/process"
import PopupWindow from "./PopupWindow"
import { Icons } from "../icons"

const weather = Variable({
  icon: "",
  condition: "",
  temp: "",
  humidity: "",
  wind: "",
  precip: "",
}).poll(
  1800000,
  ["bash", "-c", "curl -s 'wttr.in/?format=%c|||%C|||%t|||%h|||%w|||%p' 2>/dev/null || echo '?|||Unknown|||?|||?|||?|||?'"],
  (out: string) => {
    const parts = out.trim().split("|||")
    return {
      icon: parts[0]?.trim() || "?",
      condition: parts[1]?.trim() || "Unknown",
      temp: parts[2]?.trim() || "?",
      humidity: parts[3]?.trim() || "?",
      wind: parts[4]?.trim() || "?",
      precip: parts[5]?.trim() || "?",
    }
  }
)

export default function WeatherPopup() {
  return (
    <PopupWindow name="weather-popup">
      <box vertical cssClasses={["popup-content", "weather-popup"]} spacing={8}>
        <label label="Weather" cssClasses={["popup-title"]} halign={Gtk.Align.START} />

        <box spacing={12} halign={Gtk.Align.CENTER} cssClasses={["weather-hero"]}>
          <label
            label={weather().as(w => w.icon)}
            cssClasses={["weather-icon-large"]}
          />
          <box vertical>
            <label
              label={weather().as(w => w.temp)}
              cssClasses={["weather-temp"]}
            />
            <label
              label={weather().as(w => w.condition)}
              cssClasses={["dim-label"]}
            />
          </box>
        </box>

        <box vertical spacing={4} cssClasses={["detail-rows"]}>
          <box spacing={8} cssClasses={["detail-row"]}>
            <label label="Humidity" hexpand halign={Gtk.Align.START} />
            <label label={weather().as(w => w.humidity)} cssClasses={["dim-label"]} />
          </box>
          <box spacing={8} cssClasses={["detail-row"]}>
            <label label="Wind" hexpand halign={Gtk.Align.START} />
            <label label={weather().as(w => w.wind)} cssClasses={["dim-label"]} />
          </box>
          <box spacing={8} cssClasses={["detail-row"]}>
            <label label="Precipitation" hexpand halign={Gtk.Align.START} />
            <label label={weather().as(w => w.precip)} cssClasses={["dim-label"]} />
          </box>
        </box>

        <button
          cssClasses={["settings-button"]}
          onClicked={() => execAsync(["xdg-open", "https://wttr.in"])}
        >
          <box spacing={8} halign={Gtk.Align.CENTER}>
            <label label={Icons.weather} />
            <label label="Full Forecast" />
          </box>
        </button>
      </box>
    </PopupWindow>
  )
}
