import { Variable, bind } from "astal"
import { Gtk } from "astal/gtk4"
import Battery from "gi://AstalBattery"
import Wp from "gi://AstalWp"
import Network from "gi://AstalNetwork"

const battery = Battery.get_default()
const audio = Wp.get_default()
const speaker = audio?.get_default_speaker() ?? null

const clock = Variable("").poll(1000, "date +'%H:%M'")
const weather = Variable("...").poll(1800000, "curl -s 'wttr.in/?format=%c+%t' 2>/dev/null || echo '?'")
const cpu = Variable("").poll(3000, ["bash", "-c", "top -bn1 | grep 'Cpu' | awk '{print int($2+$4)}'"])
const ram = Variable("").poll(5000, ["bash", "-c", "free -h | awk '/^Mem/ {print $3}'"])

function batIconName(pct: number, charging: boolean): string {
  if (charging) return "battery-good-charging-symbolic"
  if (pct > 0.9) return "battery-full-symbolic"
  if (pct > 0.6) return "battery-good-symbolic"
  if (pct > 0.3) return "battery-low-symbolic"
  return "battery-caution-symbolic"
}

function volIconName(vol: number, muted: boolean): string {
  if (muted) return "audio-volume-muted-symbolic"
  if (vol > 0.66) return "audio-volume-high-symbolic"
  if (vol > 0.33) return "audio-volume-medium-symbolic"
  return "audio-volume-low-symbolic"
}

export default function SystemInfo() {
  const batIcon = battery
    ? bind(battery, "percentage").as((_p: number) => batIconName(battery.get_percentage(), battery.get_charging()))
    : Variable("battery-full-symbolic")()
  const batLabel = battery
    ? bind(battery, "percentage").as((p: number) => `${Math.round(p * 100)}%`)
    : Variable("")()

  const volIcon = speaker
    ? bind(speaker, "volume").as((v: number) => volIconName(v, speaker.get_mute?.() ?? false))
    : Variable("audio-volume-medium-symbolic")()
  const volLabel = speaker
    ? bind(speaker, "volume").as((v: number) => `${Math.round(v * 100)}%`)
    : Variable("--")()

  return (
    <box cssClasses={["system-info"]} spacing={4}>

      {/* Weather — wttr.in provides real emoji, no icon needed */}
      <button cssClasses={["pill", "weather-pill"]}>
        <label label={weather()} />
      </button>

      {/* CPU */}
      <button cssClasses={["pill", "cpu-pill"]}>
        <box spacing={4}>
          <image iconName="computer-symbolic" pixelSize={14} />
          <label label={cpu().as((c: string) => `${c}%`)} />
        </box>
      </button>

      {/* RAM */}
      <button cssClasses={["pill", "ram-pill"]}>
        <box spacing={4}>
          <image iconName="drive-harddisk-symbolic" pixelSize={14} />
          <label label={ram()} />
        </box>
      </button>

      {/* Volume */}
      <button cssClasses={["pill", "volume-pill"]}>
        <box spacing={4}>
          <image iconName={volIcon} pixelSize={14} />
          <label label={volLabel} />
        </box>
      </button>

      {/* Battery */}
      <button cssClasses={["pill", "battery-pill"]}>
        <box spacing={4}>
          <image iconName={batIcon} pixelSize={14} />
          <label label={batLabel} />
        </box>
      </button>

      {/* Clock */}
      <button cssClasses={["pill", "clock-pill"]}>
        <box spacing={4}>
          <image iconName="alarm-symbolic" pixelSize={14} />
          <label label={clock()} />
        </box>
      </button>

    </box>
  )
}
