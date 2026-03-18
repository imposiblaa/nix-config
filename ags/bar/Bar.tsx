import { Astal, Gtk } from "ags/gtk4"
import Workspaces from "./Workspaces"
import Media from "./Media"
import SystemInfo from "./SystemInfo"

const { TOP, LEFT, RIGHT } = Astal.WindowAnchor

export default function Bar(monitor: number) {
  return (
    <window
      visible
      class="bar"
      monitor={monitor}
      anchor={TOP | LEFT | RIGHT}
      exclusivity={Astal.Exclusivity.EXCLUSIVE}
      layer={Astal.Layer.TOP}
      marginTop={4}
      marginLeft={8}
      marginRight={8}
    >
      <centerbox>
        {/* Left: Workspaces */}
        <box halign={Gtk.Align.START} spacing={4}>
          <Workspaces />
        </box>

        {/* Center: Media */}
        <box halign={Gtk.Align.CENTER}>
          <Media />
        </box>

        {/* Right: System info */}
        <box halign={Gtk.Align.END} spacing={4}>
          <SystemInfo />
        </box>
      </centerbox>
    </window>
  )
}
