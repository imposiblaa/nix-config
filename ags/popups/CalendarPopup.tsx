import { Variable } from "astal"
import { Gtk } from "astal/gtk4"
import PopupWindow from "./PopupWindow"

const clockTime = Variable("").poll(1000, "date +'%H:%M:%S'")
const clockDate = Variable("").poll(60000, "date +'%A, %B %-d, %Y'")

export default function CalendarPopup() {
  const calendar = new Gtk.Calendar()
  calendar.cssClasses = ["calendar"]
  calendar.halign = Gtk.Align.CENTER
  calendar.hexpand = true

  return (
    <PopupWindow name="calendar-popup">
      <box vertical cssClasses={["popup-content", "calendar-popup"]} spacing={8}>
        <label label="Calendar" cssClasses={["popup-title"]} halign={Gtk.Align.START} />

        <box vertical halign={Gtk.Align.CENTER} cssClasses={["clock-hero"]}>
          <label label={clockTime()} cssClasses={["clock-time"]} />
          <label label={clockDate()} cssClasses={["dim-label"]} />
        </box>

        {calendar}
      </box>
    </PopupWindow>
  )
}
