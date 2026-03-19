import { Variable } from "astal"
import { Gtk } from "astal/gtk4"
import Battery from "gi://AstalBattery"
import Wp from "gi://AstalWp"
import Network from "gi://AstalNetwork"

const battery = Battery.get_default()
const audio = Wp.get_default()
const network = Network.get_default()

const clock = Variable("").poll(1000, "date +'%H:%M'")
const weather = Variable("...").poll(1800000, "curl -s 'wttr.in/?format=%c+%t' 2>/dev/null || echo '?'")
const cpu = Variable("").poll(3000, ["bash", "-c", "top -bn1 | grep 'Cpu' | awk '{print int($2+$4)}'"])
const ram = Variable("").poll(5000, ["bash", "-c", "free -h | awk '/^Mem/ {print $3}'"])

export default function SystemInfo() {
  return (
    <box cssClasses={["system-info"]} spacing={8}>
      <label cssClasses={["weather"]} label={weather()} />
      <label cssClasses={["cpu"]} label={cpu().as(c => ` ${c}%`)} />
      <label cssClasses={["ram"]} label={ram().as(r => ` ${r}`)} />
      <label
        cssClasses={["volume"]}
        label={audio ? Variable("").observe(audio.get_default_speaker()!, "notify::volume", () =>
          `墳 ${Math.round((audio.get_default_speaker()?.get_volume() || 0) * 100)}%`
        )() : "墳 --"}
      />
      <label
        cssClasses={["battery"]}
        label={battery ? Variable("").observe(battery, "notify::percentage", () =>
          `${Math.round((battery.get_percentage()) * 100)}%`
        )() : ""}
      />
      <label cssClasses={["clock"]} label={clock()} />
    </box>
  )
}
