import { createBinding, createComputed } from "ags"
import { Gtk } from "ags/gtk4"
import AstalMpris from "gi://AstalMpris"

const mpris = AstalMpris.Mpris.get_default()

export default function Media() {
  const players = createBinding(mpris, "players")

  const activePlayer = createComputed(() => {
    const list = players()
    // Prefer non-browser players
    const nonBrowser = list.filter(
      (p: AstalMpris.Player) =>
        !p.get_bus_name().includes("firefox") &&
        !p.get_bus_name().includes("chromium"),
    )
    return nonBrowser[0] || list[0] || null
  })

  const mediaText = createComputed(() => {
    const player = activePlayer()
    if (!player) return ""

    const title = player.get_title() || ""
    const artist = player.get_artist() || ""
    const status = player.get_playback_status()

    const icon =
      status === AstalMpris.PlaybackStatus.PLAYING
        ? "▶"
        : status === AstalMpris.PlaybackStatus.PAUSED
          ? "⏸"
          : "⏹"

    if (!title) return ""

    const text = artist ? `${title} — ${artist}` : title
    // Truncate if too long
    const maxLen = 50
    const truncated = text.length > maxLen ? text.slice(0, maxLen) + "…" : text
    return `${icon}  ${truncated}`
  })

  const visible = createComputed(() => mediaText() !== "")

  return (
    <box class="media" visible={visible}>
      <label
        class="media-text"
        label={mediaText}
        maxWidthChars={55}
        ellipsize={3} // PANGO_ELLIPSIZE_END
      />
    </box>
  )
}
