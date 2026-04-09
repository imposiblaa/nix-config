import { Variable, bind } from "astal"
import { Gtk } from "astal/gtk4"
import Network from "gi://AstalNetwork"
import { execAsync } from "astal/process"
import PopupWindow from "./PopupWindow"
import { Icons, wifiIcon } from "../icons"

export default function NetworkPopup() {
  const network = Network.get_default()
  const wifi = network.get_wifi()
  const wired = network.get_wired()
  const scanning = Variable(false)

  function doScan() {
    if (!wifi) return
    scanning.set(true)
    wifi.scan()
    setTimeout(() => scanning.set(false), 3000)
  }

  return (
    <PopupWindow name="network-popup">
      <box vertical cssClasses={["popup-content", "network-popup"]} spacing={8}>
        <box cssClasses={["popup-header"]} spacing={8}>
          <label label="Network" cssClasses={["popup-title"]} hexpand halign={Gtk.Align.START} />
          {wifi ? (
            <switch
              active={bind(wifi, "enabled")}
              onStateSet={(_: any, state: boolean) => {
                wifi.set_enabled(state)
                return false
              }}
            />
          ) : null}
        </box>

        {/* Ethernet */}
        {wired ? (
          <box vertical spacing={4} cssClasses={["current-network"]}>
            <label label="Ethernet" cssClasses={["section-label"]} halign={Gtk.Align.START} />
            <box spacing={8} cssClasses={["device-row", "active"]}>
              <label label={Icons.ethernet} />
              <label
                label={bind(wired, "speed").as((s: number) => s > 0 ? `Connected (${s} Mbps)` : "Connected")}
                hexpand
                halign={Gtk.Align.START}
              />
            </box>
          </box>
        ) : null}

        {wifi ? (
          <box vertical spacing={8}>
            {/* Current WiFi connection */}
            <box vertical spacing={4} cssClasses={["current-network"]}>
              <label label="WiFi" cssClasses={["section-label"]} halign={Gtk.Align.START} />
              <box spacing={8} cssClasses={["device-row", "active"]}>
                <label label={bind(wifi, "strength").as((s: number) => wifiIcon(s))} />
                <label
                  label={bind(wifi, "ssid").as((s: string) => s || "Not connected")}
                  hexpand
                  halign={Gtk.Align.START}
                />
                <label
                  label={bind(wifi, "strength").as((s: number) => `${s}%`)}
                  cssClasses={["dim-label"]}
                />
              </box>
            </box>

            {/* Available networks */}
            <box spacing={8}>
              <label label="Available Networks" cssClasses={["section-label"]} hexpand halign={Gtk.Align.START} />
              <button cssClasses={["scan-button"]} onClicked={doScan}>
                <box spacing={4}>
                  <label label={Icons.refresh} />
                  <label label={scanning().as((s: boolean) => s ? "Scanning..." : "Scan")} />
                </box>
              </button>
            </box>

            <box vertical spacing={4} cssClasses={["network-list"]}>
              {bind(wifi, "accessPoints").as((aps: any[]) => {
                const seen = new Set<string>()
                return (aps ?? [])
                  .filter((ap: any) => {
                    const ssid = ap.get_ssid()
                    if (!ssid || seen.has(ssid)) return false
                    seen.add(ssid)
                    return true
                  })
                  .sort((a: any, b: any) => b.get_strength() - a.get_strength())
                  .slice(0, 15)
                  .map((ap: any) => (
                    <button cssClasses={["network-row"]} onClicked={() =>
                      execAsync(["nmcli", "device", "wifi", "connect", ap.get_ssid()])
                    }>
                      <box spacing={8}>
                        <label label={wifiIcon(ap.get_strength())} />
                        <label label={ap.get_ssid()} hexpand halign={Gtk.Align.START} />
                        {ap.get_flags() > 0 ? (
                          <label label={Icons.lock} cssClasses={["dim-label"]} />
                        ) : null}
                        <label label={`${ap.get_strength()}%`} cssClasses={["dim-label"]} />
                      </box>
                    </button>
                  ))
              })}
            </box>
          </box>
        ) : (
          <label label="WiFi not available" cssClasses={["dim-label"]} />
        )}

        <button
          cssClasses={["settings-button"]}
          onClicked={() => execAsync("nm-connection-editor")}
        >
          <box spacing={8} halign={Gtk.Align.CENTER}>
            <label label={Icons.settings} />
            <label label="Network Settings" />
          </box>
        </button>
      </box>
    </PopupWindow>
  )
}
