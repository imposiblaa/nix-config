import { bind } from "astal"
import { Gtk } from "astal/gtk4"
import Mpris from "gi://AstalMpris"

const mpris = Mpris.get_default()

export default function Media() {
  const players = bind(mpris, "players")
  return (
    <box cssClasses={["media"]}>
      {players.as(ps => ps[0] ? (
        <label
          label={bind(ps[0], "title").as(t =>
            `${t || "Unknown"} — ${ps[0].get_artist() || ""}`
          )}
          maxWidthChars={40}
          ellipsize={3}
        />
      ) : <label label="" />)}
    </box>
  )
}
