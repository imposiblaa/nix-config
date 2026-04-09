import { Variable, bind, Binding } from "astal"
import { Gtk } from "astal/gtk4"
import Wp from "gi://AstalWp"
import Network from "gi://AstalNetwork"
import Bluetooth from "gi://AstalBluetooth"
import { openPopup, activePopup } from "../popups/popupManager"
import { Icons, batIcon, volIcon, wifiIcon } from "../icons"

const audio = Wp.get_default()
const speaker = audio?.get_default_speaker() ?? null
const network = Network.get_default()
const wifi = network.get_wifi()
const bt = Bluetooth.get_default()

const clock = Variable("").poll(1000, "date +'%H:%M'")
const weather = Variable("...").poll(1800000, "curl -s 'wttr.in/?format=%t' 2>/dev/null || echo '?'")
const cpu = Variable("").poll(3000, ["bash", "-c", "top -bn1 | grep 'Cpu' | awk '{print int($2+$4)}'"])
const ram = Variable("").poll(5000, ["bash", "-c", "free -h | awk '/^Mem/ {print $3}'"])
const bat = Variable({ pct: 0, charging: false }).poll(
  5000,
  ["bash", "-c", "cat /sys/class/power_supply/BAT*/capacity 2>/dev/null && echo '|||' && cat /sys/class/power_supply/BAT*/status 2>/dev/null"],
  (out: string) => {
    const [capStr, statusStr] = out.trim().split("|||").map(s => s.trim())
    const pct = parseInt(capStr || "0", 10)
    const charging = (statusStr || "").toLowerCase() === "charging"
    return { pct, charging }
  }
)

function Pill({ icon, text, popupName, pillClass, maxWidthChars, ellipsize }: {
  icon: string | Binding<string>
  text: string | Binding<string>
  popupName: string
  pillClass: string
  maxWidthChars?: number
  ellipsize?: number
}) {
  const classes = bind(activePopup).as((ap: string) =>
    ap === popupName
      ? ["pill", pillClass, "pill-active"]
      : ["pill", pillClass]
  )

  return (
    <button cssClasses={classes} onClicked={() => openPopup(popupName)}>
      <box>
        <box cssClasses={["pill-icon"]}>
          <label label={icon} />
        </box>
        <box cssClasses={["pill-text"]}>
          <label
            label={text}
            maxWidthChars={maxWidthChars ?? -1}
            ellipsize={ellipsize ?? 0}
          />
        </box>
      </box>
    </button>
  )
}

export default function SystemInfo() {
  const volIconBind = speaker
    ? bind(speaker, "volume").as((v: number) => volIcon(v, speaker.get_mute?.() ?? false))
    : Variable(Icons.volume.medium)()
  const volLabel = speaker
    ? bind(speaker, "volume").as((v: number) => `${Math.round(v * 100)}%`)
    : Variable("--")()

  return (
    <box cssClasses={["system-info"]} spacing={4}>

      {/* Weather */}
      <Pill
        icon={Icons.weather}
        text={weather()}
        popupName="weather-popup"
        pillClass="weather-pill"
      />

      {/* CPU */}
      <Pill
        icon={Icons.cpu}
        text={cpu().as((c: string) => `${c}%`)}
        popupName="system-popup"
        pillClass="cpu-pill"
      />

      {/* RAM */}
      <Pill
        icon={Icons.ram}
        text={ram()}
        popupName="system-popup"
        pillClass="ram-pill"
      />

      {/* WiFi */}
      {wifi ? (
        <Pill
          icon={bind(wifi, "strength").as((s: number) => wifiIcon(s))}
          text={bind(wifi, "ssid").as((s: string) => s || "Off")}
          popupName="network-popup"
          pillClass="network-pill"
          maxWidthChars={10}
          ellipsize={3}
        />
      ) : null}

      {/* Bluetooth */}
      <Pill
        icon={Icons.bluetooth}
        text={bind(bt, "devices").as((devs: any[]) => {
          const connected = devs.filter((d: any) => d.get_connected())
          return connected.length > 0 ? connected[0].get_alias() : "Off"
        })}
        popupName="bluetooth-popup"
        pillClass="bluetooth-pill"
        maxWidthChars={10}
        ellipsize={3}
      />

      {/* Volume */}
      <Pill
        icon={volIconBind}
        text={volLabel}
        popupName="volume-popup"
        pillClass="volume-pill"
      />

      {/* Battery */}
      <Pill
        icon={bat().as(b => batIcon(b.pct, b.charging))}
        text={bat().as(b => `${b.pct}%`)}
        popupName="battery-popup"
        pillClass="battery-pill"
      />

      {/* Clock */}
      <Pill
        icon={Icons.clock}
        text={clock()}
        popupName="calendar-popup"
        pillClass="clock-pill"
      />

    </box>
  )
}
