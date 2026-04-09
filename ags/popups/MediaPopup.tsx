import { bind } from "astal"
import { Gtk } from "astal/gtk4"
import Mpris from "gi://AstalMpris"
import PopupWindow from "./PopupWindow"
import { Icons } from "../icons"

const mpris = Mpris.get_default()

function PlayerControls({ player }: { player: any }) {
  return (
    <box vertical spacing={8}>
      <box spacing={12} halign={Gtk.Align.CENTER} cssClasses={["media-hero"]}>
        <label label={Icons.media.music} cssClasses={["media-icon-large"]} />
        <box vertical>
          <label
            label={bind(player, "title").as((t: string) => t || "Unknown")}
            cssClasses={["media-title"]}
            maxWidthChars={25}
            ellipsize={3}
            halign={Gtk.Align.START}
          />
          <label
            label={bind(player, "artist").as((a: string) => a || "Unknown Artist")}
            cssClasses={["dim-label"]}
            maxWidthChars={25}
            ellipsize={3}
            halign={Gtk.Align.START}
          />
        </box>
      </box>

      <box spacing={16} halign={Gtk.Align.CENTER} cssClasses={["media-controls"]}>
        <button cssClasses={["icon-button"]} onClicked={() => player.previous()}>
          <label label={Icons.media.prev} cssClasses={["nf-icon-lg"]} />
        </button>
        <button cssClasses={["icon-button", "media-play-btn"]} onClicked={() => player.play_pause()}>
          <label
            label={bind(player, "playbackStatus").as((s: number) =>
              s === Mpris.PlaybackStatus.PLAYING ? Icons.media.pause : Icons.media.play
            )}
            cssClasses={["media-play-icon"]}
          />
        </button>
        <button cssClasses={["icon-button"]} onClicked={() => player.next()}>
          <label label={Icons.media.next} cssClasses={["nf-icon-lg"]} />
        </button>
      </box>

      <box vertical spacing={4} cssClasses={["detail-rows"]}>
        <box spacing={8} cssClasses={["detail-row"]}>
          <label label="Album" hexpand halign={Gtk.Align.START} />
          <label
            label={bind(player, "album").as((a: string) => a || "—")}
            cssClasses={["dim-label"]}
            maxWidthChars={20}
            ellipsize={3}
          />
        </box>
        <box spacing={8} cssClasses={["detail-row"]}>
          <label label="Source" hexpand halign={Gtk.Align.START} />
          <label
            label={bind(player, "identity").as((i: string) => i || "—")}
            cssClasses={["dim-label"]}
          />
        </box>
      </box>
    </box>
  )
}

export default function MediaPopup() {
  return (
    <PopupWindow name="media-popup">
      <box vertical cssClasses={["popup-content", "media-popup"]} spacing={8}>
        <label label="Media" cssClasses={["popup-title"]} halign={Gtk.Align.START} />

        {bind(mpris, "players").as((players: any[]) =>
          players.length > 0 ? (
            <PlayerControls player={players[0]} />
          ) : (
            <box halign={Gtk.Align.CENTER} cssClasses={["media-hero"]}>
              <label label="No media playing" cssClasses={["dim-label"]} />
            </box>
          )
        )}
      </box>
    </PopupWindow>
  )
}
