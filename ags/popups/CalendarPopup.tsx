import { Gtk } from "astal/gtk4"
import PopupWindow from "./PopupWindow"

export default function CalendarPopup() {
  const calendar = new Gtk.Calendar()
  calendar.cssClasses = ["calendar"]

  return (
    <PopupWindow name="calendar-popup">
      <box vertical cssClasses={["popup-content", "calendar-popup"]} spacing={8}>
        <label label="Calendar" cssClasses={["popup-title"]} halign={Gtk.Align.START} />
        {calendar}
      </box>
    </PopupWindow>
  )
}
