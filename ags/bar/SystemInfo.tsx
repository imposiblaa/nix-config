import { Variable, bind, Binding } from "astal"
import { Gtk } from "astal/gtk4"
import Wp from "gi://AstalWp"
import Network from "gi://AstalNetwork"
import Bluetooth from "gi://AstalBluetooth"
import Mpris from "gi://AstalMpris"
import Tray from "gi://AstalTray"
import { openPopup, activePopup } from "../popups/popupManager"
import { Icons, batIcon, volIcon, wifiIcon } from "../icons"

const audio = Wp.get_default()
const speaker = audio?.get_default_speaker() ?? null
const network = Network.get_default()
const wifi = network.get_wifi()
const bt = Bluetooth.get_default()
const mpris = Mpris.get_default()
const tray = Tray.get_default()

const clock = Variable("").poll(1000, "date +'%H:%M'")
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

function MarqueeLabel({ text, maxChars = 15, speed = 300 }: {
  text: string | Binding<string>
  maxChars?: number
  speed?: number
}) {
  const offset = Variable(0)
  let currentText = ""

  const resolvedText = typeof text === "string" ? Variable(text)() : text

  const display = Variable.derive(
    [resolvedText, offset()],
    (t: string, o: number) => {
      currentText = t
      if (t.length <= maxChars) return t
      const padded = t + "   " + t
      return padded.substring(o, o + maxChars)
    }
  )

  const timer = setInterval(() => {
    if (currentText.length > maxChars) {
      const padLen = currentText.length + 3
      offset.set((offset.get() + 1) % padLen)
    } else {
      offset.set(0)
    }
  }, speed)

  return (
    <label
      label={display()}
      onDestroy={() => clearInterval(timer)}
      widthChars={maxChars}
    />
  )
}

function Pill({ icon, text, popupName, pillClass, maxWidthChars, ellipsize, marquee }: {
  icon: string | Binding<string>
  text: string | Binding<string>
  popupName: string
  pillClass: string
  maxWidthChars?: number
  ellipsize?: number
  marquee?: boolean
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
          {marquee ? (
            <MarqueeLabel text={text} maxChars={maxWidthChars ?? 10} />
          ) : (
            <label
              label={text}
              maxWidthChars={maxWidthChars ?? -1}
              ellipsize={ellipsize ?? 0}
            />
          )}
        </box>
      </box>
    </button>
  )
}

const trayRevealed = Variable(false)

export default function SystemInfo() {
  const volIconBind = speaker
    ? bind(speaker, "volume").as((v: number) => volIcon(v, speaker.get_mute?.() ?? false))
    : Variable(Icons.volume.medium)()
  const volLabel = speaker
    ? bind(speaker, "volume").as((v: number) => `${Math.round(v * 100)}%`)
    : Variable("--")()

  const mediaText = bind(mpris, "players").as((ps: any[]) =>
    ps[0] ? `${ps[0].get_title() || "Unknown"} — ${ps[0].get_artist() || ""}` : "No Media"
  )
  const mediaIcon = bind(mpris, "players").as((ps: any[]) =>
    ps[0] ? Icons.media.music : Icons.media.music
  )

  return (
    <box cssClasses={["system-info"]} spacing={4}>

      {/* Media */}
      <Pill
        icon={mediaIcon}
        text={mediaText}
        popupName="media-popup"
        pillClass="media-pill"
        maxWidthChars={15}
        marquee
      />

      {/* CPU + RAM */}
      <button
        cssClasses={bind(activePopup).as((ap: string) =>
          ap === "system-popup"
            ? ["pill", "system-pill", "pill-active"]
            : ["pill", "system-pill"]
        )}
        onClicked={() => openPopup("system-popup")}
      >
        <box>
          <box cssClasses={["pill-icon", "cpu-icon"]}>
            <label label={Icons.cpu} />
          </box>
          <box cssClasses={["pill-text"]}>
            <label label={cpu().as((c: string) => `${c}%`)} />
          </box>
          <box cssClasses={["pill-separator"]} />
          <box cssClasses={["pill-icon", "ram-icon"]}>
            <label label={Icons.ram} />
          </box>
          <box cssClasses={["pill-text"]}>
            <label label={ram()} />
          </box>
        </box>
      </button>

      {/* WiFi */}
      {wifi ? (
        <Pill
          icon={bind(wifi, "strength").as((s: number) => wifiIcon(s))}
          text={bind(wifi, "ssid").as((s: string) => s || "Off")}
          popupName="network-popup"
          pillClass="network-pill"
          maxWidthChars={10}
          marquee
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
        marquee
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

      {/* Tray toggle */}
      <button
        cssClasses={["pill", "tray-toggle"]}
        onClicked={() => trayRevealed.set(!trayRevealed.get())}
      >
        <label label={trayRevealed().as((r: boolean) => r ? Icons.chevron.right : Icons.chevron.left)} />
      </button>

      {/* System tray */}
      <revealer
        revealChild={trayRevealed()}
        transitionType={Gtk.RevealerTransitionType.SLIDE_LEFT}
        transitionDuration={200}
      >
        <box spacing={4} cssClasses={["tray-items"]}>
          {bind(tray, "items").as((items: any[]) =>
            items.map((item: any) => (
              <button
                cssClasses={["tray-item"]}
                onClicked={(self: any) => {
                  const menu = item.create_menu()
                  if (menu) {
                    menu.set_parent(self)
                    menu.popup()
                  }
                }}
              >
                <image gIcon={bind(item, "gicon")} />
              </button>
            ))
          )}
        </box>
      </revealer>

    </box>
  )
}
