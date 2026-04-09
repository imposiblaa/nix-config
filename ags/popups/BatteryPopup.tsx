import { Variable } from "astal"
import { Gtk } from "astal/gtk4"
import PopupWindow from "./PopupWindow"
import { batIcon } from "../icons"

function formatTime(seconds: number): string {
  if (seconds <= 0) return "N/A"
  const h = Math.floor(seconds / 3600)
  const m = Math.floor((seconds % 3600) / 60)
  return h > 0 ? `${h}h ${m}m` : `${m}m`
}

const bat = Variable({
  pct: 0,
  charging: false,
  status: "Unknown",
  timeToEmpty: 0,
  timeToFull: 0,
  energyRate: 0,
}).poll(
  5000,
  ["bash", "-c", `
    cap=$(cat /sys/class/power_supply/BAT*/capacity 2>/dev/null | head -1)
    status=$(cat /sys/class/power_supply/BAT*/status 2>/dev/null | head -1)
    power=$(cat /sys/class/power_supply/BAT*/power_now 2>/dev/null | head -1)
    energy=$(cat /sys/class/power_supply/BAT*/energy_now 2>/dev/null | head -1)
    energy_full=$(cat /sys/class/power_supply/BAT*/energy_full 2>/dev/null | head -1)
    echo "\${cap:-0}|||\${status:-Unknown}|||\${power:-0}|||\${energy:-0}|||\${energy_full:-0}"
  `],
  (out: string) => {
    const parts = out.trim().split("|||")
    const pct = parseInt(parts[0] || "0", 10)
    const status = parts[1] || "Unknown"
    const charging = status.toLowerCase() === "charging"
    const powerUw = parseInt(parts[2] || "0", 10)
    const energyUw = parseInt(parts[3] || "0", 10)
    const energyFullUw = parseInt(parts[4] || "0", 10)
    const powerW = powerUw / 1000000
    let timeToEmpty = 0
    let timeToFull = 0
    if (powerUw > 0 && !charging) {
      timeToEmpty = (energyUw / powerUw) * 3600
    }
    if (powerUw > 0 && charging) {
      timeToFull = ((energyFullUw - energyUw) / powerUw) * 3600
    }
    return { pct, charging, status, timeToEmpty, timeToFull, energyRate: powerW }
  }
)

export default function BatteryPopup() {
  return (
    <PopupWindow name="battery-popup">
      <box vertical cssClasses={["popup-content", "battery-popup"]} spacing={8}>
        <label label="Battery" cssClasses={["popup-title"]} halign={Gtk.Align.START} />

        <box spacing={16} halign={Gtk.Align.CENTER} cssClasses={["battery-hero"]}>
          <label
            label={bat().as(b => batIcon(b.pct, b.charging))}
            cssClasses={["battery-icon-large"]}
          />
          <box vertical>
            <label
              label={bat().as(b => `${b.pct}%`)}
              cssClasses={["battery-percentage"]}
            />
            <label
              label={bat().as(b => b.status)}
              cssClasses={["dim-label"]}
            />
          </box>
        </box>

        <box vertical spacing={4} cssClasses={["detail-rows"]}>
          <box spacing={8} cssClasses={["detail-row"]}>
            <label label="Time Remaining" hexpand halign={Gtk.Align.START} />
            <label
              label={bat().as(b => formatTime(b.timeToEmpty))}
              cssClasses={["dim-label"]}
            />
          </box>
          <box spacing={8} cssClasses={["detail-row"]}>
            <label label="Time to Full" hexpand halign={Gtk.Align.START} />
            <label
              label={bat().as(b => formatTime(b.timeToFull))}
              cssClasses={["dim-label"]}
            />
          </box>
          <box spacing={8} cssClasses={["detail-row"]}>
            <label label="Power Draw" hexpand halign={Gtk.Align.START} />
            <label
              label={bat().as(b => `${b.energyRate.toFixed(1)} W`)}
              cssClasses={["dim-label"]}
            />
          </box>
        </box>
      </box>
    </PopupWindow>
  )
}
