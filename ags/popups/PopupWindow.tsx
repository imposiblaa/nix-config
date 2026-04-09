import { App, Astal, Gtk, Gdk } from "astal/gtk4"
import { closeAllPopups } from "./popupManager"

const { TOP, BOTTOM, LEFT, RIGHT } = Astal.WindowAnchor

export default function PopupWindow({
  name,
  child,
}: {
  name: string
  child: JSX.Element
}) {
  const click = new Gtk.GestureClick()
  click.connect("pressed", (_gesture: any, _n: number) => {
    click.set_state(Gtk.EventSequenceState.CLAIMED)
  })

  return (
    <window
      name={name}
      visible={false}
      cssClasses={["popup-window"]}
      anchor={TOP | BOTTOM | LEFT | RIGHT}
      layer={Astal.Layer.OVERLAY}
      exclusivity={Astal.Exclusivity.NORMAL}
      keymode={Astal.Keymode.ON_DEMAND}
      application={App}
      onKeyPressed={(_self: any, keyval: number) => {
        if (keyval === Gdk.KEY_Escape) closeAllPopups()
      }}
      onButtonReleased={() => closeAllPopups()}
    >
      <box halign={Gtk.Align.END} valign={Gtk.Align.START} cssClasses={["popup-positioner"]}>
        <box cssClasses={["popup-container"]} setup={(self: any) => self.add_controller(click)}>
          {child}
        </box>
      </box>
    </window>
  )
}
