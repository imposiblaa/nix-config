import { App, Astal, Gtk, Gdk } from "astal/gtk4"
import { Variable } from "astal"
import Workspaces from "./Workspaces"
import Media from "./Media"
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
      marginTop={4}
      marginLeft={8}
      marginRight={8}
      application={App}
    >
      <centerbox>
        <box halign={Gtk.Align.START} spacing={4}>
          <Workspaces />
        </box>
        <box halign={Gtk.Align.CENTER}>
          <Media />
        </box>
        <box halign={Gtk.Align.END} spacing={4}>
          <SystemInfo />
        </box>
      </centerbox>
    </window>
  )
}
