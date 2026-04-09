import { App, Astal, Gtk, Gdk } from "astal/gtk4"
import { closeAllPopups } from "./popupManager"

const { TOP, RIGHT } = Astal.WindowAnchor

export default function PopupWindow({
  name,
  child,
}: {
  name: string
  child: JSX.Element
}) {
  return (
    <window
      name={name}
      visible={false}
      cssClasses={["popup-window"]}
      anchor={TOP | RIGHT}
      layer={Astal.Layer.OVERLAY}
      exclusivity={Astal.Exclusivity.NORMAL}
      keymode={Astal.Keymode.ON_DEMAND}
      marginTop={40}
      marginRight={8}
      application={App}
      onKeyPressed={(_self: any, keyval: number) => {
        if (keyval === Gdk.KEY_Escape) closeAllPopups()
      }}
    >
      <box cssClasses={["popup-container"]}>
        {child}
      </box>
    </window>
  )
}
