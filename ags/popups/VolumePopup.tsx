import { bind } from "astal"
import { Gtk } from "astal/gtk4"
import Wp from "gi://AstalWp"
import { execAsync } from "astal/process"
import PopupWindow from "./PopupWindow"
import { Icons, volIcon } from "../icons"

export default function VolumePopup() {
  const audio = Wp.get_default()
  const speaker = audio?.get_default_speaker() ?? null

  return (
    <PopupWindow name="volume-popup">
      <box vertical cssClasses={["popup-content", "volume-popup"]} spacing={8}>
        <label label="Volume" cssClasses={["popup-title"]} halign={Gtk.Align.START} />

        {speaker ? (
          <box vertical spacing={8}>
            <box spacing={8} cssClasses={["volume-control"]}>
              <button
                cssClasses={["icon-button"]}
                onClicked={() => speaker.set_mute(!speaker.get_mute())}
              >
                <label
                  label={bind(speaker, "mute").as((m: boolean) =>
                    m ? Icons.volume.muted : Icons.volume.high
                  )}
                  cssClasses={["nf-icon-lg"]}
                />
              </button>
              <slider
                cssClasses={["volume-slider"]}
                hexpand
                value={bind(speaker, "volume")}
                onChangeValue={(_self: any) => {
                  speaker.set_volume(_self.value)
                }}
              />
              <label
                label={bind(speaker, "volume").as((v: number) => `${Math.round(v * 100)}%`)}
                cssClasses={["dim-label"]}
                widthChars={4}
              />
            </box>

            <label label="Output Devices" cssClasses={["section-label"]} halign={Gtk.Align.START} />
            <box vertical spacing={4}>
              {bind(audio!, "speakers").as((speakers: any[]) =>
                (speakers ?? []).map((s: any) => (
                  <button
                    cssClasses={bind(s, "isDefault").as((d: boolean) =>
                      d ? ["device-row", "active"] : ["device-row"]
                    )}
                    onClicked={() => s.set_is_default(true)}
                  >
                    <box spacing={8}>
                      <label label={Icons.speaker} />
                      <label label={bind(s, "description")} hexpand halign={Gtk.Align.START} />
                      <label
                        label={Icons.check}
                        visible={bind(s, "isDefault")}
                      />
                    </box>
                  </button>
                ))
              )}
            </box>
          </box>
        ) : (
          <label label="No audio device found" cssClasses={["dim-label"]} />
        )}

        <button
          cssClasses={["settings-button"]}
          onClicked={() => execAsync("pavucontrol")}
        >
          <box spacing={8} halign={Gtk.Align.CENTER}>
            <label label={Icons.settings} />
            <label label="Open Pavucontrol" />
          </box>
        </button>
      </box>
    </PopupWindow>
  )
}
