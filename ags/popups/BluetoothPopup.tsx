import { Variable, bind } from "astal"
import { Gtk } from "astal/gtk4"
import Bluetooth from "gi://AstalBluetooth"
import { execAsync } from "astal/process"
import PopupWindow from "./PopupWindow"
import { Icons } from "../icons"

export default function BluetoothPopup() {
  const bt = Bluetooth.get_default()
  const adapter = bt.get_adapter()
  const scanning = Variable(false)

  function toggleScan() {
    if (!adapter) return
    if (scanning.get()) {
      adapter.stop_discovery()
      scanning.set(false)
    } else {
      adapter.start_discovery()
      scanning.set(true)
      setTimeout(() => {
        try { adapter.stop_discovery() } catch {}
        scanning.set(false)
      }, 10000)
    }
  }

  return (
    <PopupWindow name="bluetooth-popup">
      <box vertical cssClasses={["popup-content", "bluetooth-popup"]} spacing={8}>
        <box cssClasses={["popup-header"]} spacing={8}>
          <label label="Bluetooth" cssClasses={["popup-title"]} hexpand halign={Gtk.Align.START} />
          {adapter ? (
            <switch
              active={bind(adapter, "powered")}
              onStateSet={(_: any, state: boolean) => {
                adapter.set_powered(state)
                return false
              }}
            />
          ) : null}
        </box>

        <box spacing={8}>
          <label label="Devices" cssClasses={["section-label"]} hexpand halign={Gtk.Align.START} />
          <button cssClasses={["scan-button"]} onClicked={toggleScan}>
            <box spacing={4}>
              <label label={Icons.refresh} />
              <label label={scanning().as((s: boolean) => s ? "Scanning..." : "Scan")} />
            </box>
          </button>
        </box>

        <box vertical spacing={4} cssClasses={["device-list"]}>
          {bind(bt, "devices").as((devices: any[]) =>
            (devices ?? [])
              .filter((d: any) => d.get_paired() || d.get_connected())
              .map((device: any) => (
                <button
                  cssClasses={bind(device, "connected").as((c: boolean) =>
                    c ? ["device-row", "active"] : ["device-row"]
                  )}
                  onClicked={() => {
                    if (device.get_connected()) {
                      device.disconnect_device(() => {})
                    } else {
                      device.connect_device(() => {})
                    }
                  }}
                >
                  <box spacing={8}>
                    <label label={Icons.bluetooth} />
                    <label label={bind(device, "alias")} hexpand halign={Gtk.Align.START} />
                    <label
                      label={bind(device, "connected").as((c: boolean) => c ? "Connected" : "Paired")}
                      cssClasses={["dim-label"]}
                    />
                    <label
                      label={bind(device, "batteryPercentage").as((p: number) =>
                        p >= 0 ? `${Math.round(p)}%` : ""
                      )}
                      cssClasses={["dim-label"]}
                    />
                  </box>
                </button>
              ))
          )}
        </box>

        <button
          cssClasses={["settings-button"]}
          onClicked={() => execAsync("blueman-manager")}
        >
          <box spacing={8} halign={Gtk.Align.CENTER}>
            <label label={Icons.settings} />
            <label label="Bluetooth Settings" />
          </box>
        </button>
      </box>
    </PopupWindow>
  )
}
