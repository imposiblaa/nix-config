import { App, Astal, Gtk, Gdk } from "astal/gtk4"
import Workspaces from "./Workspaces"
import SystemInfo from "./SystemInfo"

const { TOP, LEFT, RIGHT } = Astal.WindowAnchor

export default function Bar(gdkmonitor: Gdk.Monitor) {
  return (
    <window
      visible
      cssClasses={["bar"]}
      gdkmonitor={gdkmonitor}
      exclusivity={Astal.Exclusivity.EXCLUSIVE}
      anchor={TOP | LEFT | RIGHT}
      application={App}
    >
      <centerbox>
        <box halign={Gtk.Align.START} spacing={4}>
          <Workspaces gdkmonitor={gdkmonitor} />
        </box>
        <box halign={Gtk.Align.CENTER} />

        <box halign={Gtk.Align.END} spacing={4}>
          <SystemInfo />
        </box>
      </centerbox>
    </window>
  )
}
