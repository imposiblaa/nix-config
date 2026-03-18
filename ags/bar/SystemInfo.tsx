import { createBinding, createComputed } from "ags"
import { createPoll } from "ags/time"
import { Gtk } from "ags/gtk4"
import AstalBattery from "gi://AstalBattery"
import AstalNetwork from "gi://AstalNetwork"
import AstalWp from "gi://AstalWp"

// Battery
const battery = AstalBattery.get_default()
const batteryPercentage = createBinding(battery, "percentage")
const batteryCharging = createBinding(battery, "charging")
const batteryPresent = createBinding(battery, "is-present")

function BatteryWidget() {
  const label = createComputed(() => {
    const pct = Math.round(batteryPercentage() * 100)
    const charging = batteryCharging()

    let icon = ""
    if (charging) {
      icon = "󰂄"
    } else if (pct >= 90) {
      icon = "󰁹"
    } else if (pct >= 70) {
      icon = "󰂁"
    } else if (pct >= 50) {
      icon = "󰁾"
    } else if (pct >= 30) {
      icon = "󰁻"
    } else if (pct >= 15) {
      icon = "󰁺"
    } else {
      icon = "󰂎"
    }

    return `${icon} ${pct}%`
  })

  const cssClass = createComputed(() => {
    const pct = Math.round(batteryPercentage() * 100)
    const charging = batteryCharging()
    if (charging) return "battery charging"
    if (pct <= 15) return "battery critical"
    if (pct <= 30) return "battery warning"
    return "battery"
  })

  return (
    <box
      class={cssClass}
      visible={batteryPresent}
    >
      <label label={label} />
    </box>
  )
}

// Network
const network = AstalNetwork.get_default()

function NetworkWidget() {
  const wifi = createBinding(network, "wifi")
  const wired = createBinding(network, "wired")
  const connectivity = createBinding(network, "connectivity")

  const label = createComputed(() => {
    const w = wifi()
    if (w && w.get_state() === AstalNetwork.DeviceState.ACTIVATED) {
      const ssid = w.get_ssid() || ""
      const strength = w.get_strength()
      let icon = "󰤭"
      if (strength >= 80) icon = "󰤨"
      else if (strength >= 60) icon = "󰤥"
      else if (strength >= 40) icon = "󰤢"
      else if (strength >= 20) icon = "󰤟"
      return `${icon} ${strength}%`
    }

    const e = wired()
    if (e && e.get_state() === AstalNetwork.DeviceState.ACTIVATED) {
      return "󰈀 eth"
    }

    return "󰤭 off"
  })

  return (
    <box class="network">
      <label label={label} />
    </box>
  )
}

// Volume
function VolumeWidget() {
  const wireplumber = AstalWp.get_default()
  const speaker = createBinding(wireplumber, "default-speaker")

  const label = createComputed(() => {
    const s = speaker()
    if (!s) return "󰝟 --"
    const vol = Math.round(s.get_volume() * 100)
    const muted = s.get_mute()
    if (muted) return `󰝟 ${vol}%`
    if (vol >= 70) return `󰕾 ${vol}%`
    if (vol >= 30) return `󰖀 ${vol}%`
    return `󰕿 ${vol}%`
  })

  return (
    <box class="volume">
      <label label={label} />
    </box>
  )
}

// CPU and RAM (polled)
const cpuPoll = createPoll("CPU 0%", 5000, async () => {
  const { execAsync } = await import("ags/process")
  try {
    const out = await execAsync([
      "bash",
      "-c",
      "top -bn1 | grep 'Cpu(s)' | awk '{print $2}' | cut -d'%' -f1",
    ])
    const val = parseFloat(out.trim())
    if (isNaN(val)) return " 0%"
    return ` ${Math.round(val)}%`
  } catch {
    return " 0%"
  }
})

const ramPoll = createPoll(" 0G", 5000, async () => {
  const { execAsync } = await import("ags/process")
  try {
    const out = await execAsync([
      "bash",
      "-c",
      "free -m | awk 'NR==2{printf \"%.1f\", $3/1024}'",
    ])
    return ` ${out.trim()}G`
  } catch {
    return " 0G"
  }
})

// Weather (polled every 30 minutes)
const weatherPoll = createPoll("", 1800000, async () => {
  const { execAsync } = await import("ags/process")
  try {
    const out = await execAsync([
      "bash",
      "-c",
      "curl -s 'wttr.in/?format=%c+%t' 2>/dev/null",
    ])
    return out.trim()
  } catch {
    return ""
  }
})

// Clock (updated every 60 seconds)
const clockPoll = createPoll("", 60000, async () => {
  const { execAsync } = await import("ags/process")
  try {
    const out = await execAsync(["bash", "-c", "date '+%H:%M  %a %b %-d'"])
    return out.trim()
  } catch {
    return ""
  }
})

export default function SystemInfo() {
  const weatherVisible = createComputed(() => weatherPoll() !== "")

  return (
    <box class="system-info" spacing={4}>
      {/* Weather */}
      <box class="pill weather" visible={weatherVisible}>
        <label label={weatherPoll} />
      </box>

      {/* CPU */}
      <box class="pill cpu">
        <label label={cpuPoll} />
      </box>

      {/* RAM */}
      <box class="pill ram">
        <label label={ramPoll} />
      </box>

      {/* Volume */}
      <box class="pill">
        <VolumeWidget />
      </box>

      {/* Battery */}
      <box class="pill">
        <BatteryWidget />
      </box>

      {/* Network */}
      <box class="pill">
        <NetworkWidget />
      </box>

      {/* Clock */}
      <box class="pill clock">
        <label label={clockPoll} />
      </box>
    </box>
  )
}
