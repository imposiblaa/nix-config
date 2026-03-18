import { createBinding, createComputed } from "ags"
import { Gtk } from "ags/gtk4"
import AstalHyprland from "gi://AstalHyprland"

const hyprland = AstalHyprland.get_default()

function WorkspaceButton({ id }: { id: number }) {
  const workspaces = createBinding(hyprland, "workspaces")
  const focusedWorkspace = createBinding(hyprland, "focused-workspace")

  const isActive = createComputed(() => {
    const focused = focusedWorkspace()
    return focused != null && focused.get_id() === id
  })

  const hasWindows = createComputed(() => {
    const wsList = workspaces()
    const ws = wsList.find((w: AstalHyprland.Workspace) => w.get_id() === id)
    return ws != null && ws.get_client_count() > 0
  })

  const cssClass = createComputed(() => {
    if (isActive()) return "workspace active"
    if (hasWindows()) return "workspace occupied"
    return "workspace"
  })

  return (
    <button
      class={cssClass}
      onClicked={() => {
        hyprland.dispatch("workspace", id.toString())
      }}
    >
      <label label={id.toString()} />
    </button>
  )
}

export default function Workspaces() {
  // Workspaces 1-6 per monitor (split-monitor-workspaces uses 1-6 per screen)
  const workspaceIds = [1, 2, 3, 4, 5, 6]

  return (
    <box class="workspaces" spacing={2}>
      {workspaceIds.map((id) => (
        <WorkspaceButton id={id} />
      ))}
    </box>
  )
}
