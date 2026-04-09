import { Variable, bind } from "astal"
import { Gtk, Gdk } from "astal/gtk4"
import Hyprland from "gi://AstalHyprland"

const hyprland = Hyprland.get_default()

var idRecord: Record<string, number> = {}

function WorkspaceButton({ id, monitorName }: { id: number; monitorName: string }) {
  const focused = bind(hyprland, "focusedWorkspace")
  return (
    <button
      cssClasses={focused.as(fw => {
        if (!fw) return ["workspace"]
        const fwMon = fw.get_monitor()
        if (!fwMon || fwMon.get_name() !== monitorName) return ["workspace"]
        const relId = ((fw.get_id() - 1) % 6) + 1
        return relId === id ? ["workspace", "active"] : ["workspace"]
      })}
      onClicked={() => hyprland.dispatch("split-workspace", String(id))}
    >
      <label label={focused.as(fw => {
        const relId = ((fw.get_id() - 1) % 6) + 1
        const fwMon = fw.get_monitor()
        const localId = fwMon ? idRecord[monitorName] : 0
        if (!fwMon || fwMon.get_name() !== monitorName) {
          return localId && localId === id ? "•" : "◦"
        } else {
          idRecord[monitorName] = relId
          return relId === id ? String(id) : "◦"
        }
      })} />
    </button>
  )
}

export default function Workspaces({ gdkmonitor }: { gdkmonitor: Gdk.Monitor }) {
  const monitorName = gdkmonitor.get_connector() || ""
  return (
    <box cssClasses={["workspaces"]} spacing={2}>
      {[1, 2, 3, 4, 5, 6].map(id => <WorkspaceButton id={id} monitorName={monitorName} />)}
    </box>
  )
}
