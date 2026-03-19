import { Variable, bind } from "astal"
import { Gtk } from "astal/gtk4"
import Hyprland from "gi://AstalHyprland"

const hyprland = Hyprland.get_default()

function WorkspaceButton({ id }: { id: number }) {
  const focused = bind(hyprland, "focusedWorkspace")
  return (
    <button
      cssClasses={focused.as(fw =>
        fw && fw.get_id() === id ? ["workspace", "active"] : ["workspace"]
      )}
      onClicked={() => hyprland.dispatch("workspace", String(id))}
    >
      <label label={String(id)} />
    </button>
  )
}

export default function Workspaces() {
  return (
    <box cssClasses={["workspaces"]} spacing={2}>
      {[1, 2, 3, 4, 5, 6].map(id => <WorkspaceButton id={id} />)}
    </box>
  )
}
