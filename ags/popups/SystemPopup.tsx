import { Variable } from "astal"
import { Gtk } from "astal/gtk4"
import { execAsync } from "astal/process"
import PopupWindow from "./PopupWindow"
import { Icons } from "../icons"

const stats = Variable({ cpu: "", ram: "", swap: "", load: "", uptime: "", procs: [] as string[] }).poll(
  3000,
  ["bash", "-c", `
    cpu=$(top -bn1 | grep 'Cpu' | awk '{printf "%.0f%%", $2+$4}')
    ram=$(free -h | awk '/^Mem/ {printf "%s / %s", $3, $2}')
    swap=$(free -h | awk '/^Swap/ {printf "%s / %s", $3, $2}')
    load=$(cat /proc/loadavg | awk '{print $1, $2, $3}')
    uptime=$(uptime -p | sed 's/^up //')
    procs=$(ps aux --sort=-%cpu | awk 'NR>1 && NR<=6 {printf "%s %s%% %s\\n", $11, $3, $4}')
    echo "$cpu|||$ram|||$swap|||$load|||$uptime|||$procs"
  `],
  (out: string) => {
    const parts = out.trim().split("|||")
    return {
      cpu: parts[0] || "",
      ram: parts[1] || "",
      swap: parts[2] || "",
      load: parts[3] || "",
      uptime: parts[4] || "",
      procs: (parts[5] || "").split("\n").filter(Boolean),
    }
  }
)

export default function SystemPopup() {
  return (
    <PopupWindow name="system-popup">
      <box vertical cssClasses={["popup-content", "system-popup"]} spacing={8}>
        <label label="System" cssClasses={["popup-title"]} halign={Gtk.Align.START} />

        <box vertical spacing={4} cssClasses={["detail-rows"]}>
          <box spacing={8} cssClasses={["detail-row"]}>
            <label label="CPU" hexpand halign={Gtk.Align.START} />
            <label label={stats().as(s => s.cpu)} cssClasses={["dim-label"]} />
          </box>
          <box spacing={8} cssClasses={["detail-row"]}>
            <label label="RAM" hexpand halign={Gtk.Align.START} />
            <label label={stats().as(s => s.ram)} cssClasses={["dim-label"]} />
          </box>
          <box spacing={8} cssClasses={["detail-row"]}>
            <label label="Swap" hexpand halign={Gtk.Align.START} />
            <label label={stats().as(s => s.swap)} cssClasses={["dim-label"]} />
          </box>
          <box spacing={8} cssClasses={["detail-row"]}>
            <label label="Load" hexpand halign={Gtk.Align.START} />
            <label label={stats().as(s => s.load)} cssClasses={["dim-label"]} />
          </box>
          <box spacing={8} cssClasses={["detail-row"]}>
            <label label="Uptime" hexpand halign={Gtk.Align.START} />
            <label label={stats().as(s => s.uptime)} cssClasses={["dim-label"]} />
          </box>
        </box>

        <label label="Top Processes" cssClasses={["section-label"]} halign={Gtk.Align.START} />
        <box vertical spacing={2} cssClasses={["process-list"]}>
          {stats().as(s =>
            s.procs.map((p: string) => {
              const parts = p.split(" ")
              const name = (parts[0] || "").split("/").pop() || parts[0]
              const cpu = parts[1] || ""
              const mem = parts[2] || ""
              return (
                <box spacing={8} cssClasses={["process-row"]}>
                  <label label={name || ""} hexpand halign={Gtk.Align.START} maxWidthChars={20} ellipsize={3} />
                  <label label={`CPU: ${cpu}`} cssClasses={["dim-label"]} widthChars={10} />
                  <label label={`MEM: ${mem}%`} cssClasses={["dim-label"]} widthChars={10} />
                </box>
              )
            })
          )}
        </box>

        <button
          cssClasses={["settings-button"]}
          onClicked={() => execAsync(["kitty", "btop"])}
        >
          <box spacing={8} halign={Gtk.Align.CENTER}>
            <label label={Icons.monitor} />
            <label label="Open btop" />
          </box>
        </button>
      </box>
    </PopupWindow>
  )
}
