// Nerd Font icons (JetBrainsMono Nerd Font Mono)
// Material Design Icons + Font Awesome from nerdfonts.com

export const Icons = {
  battery: {
    charging: "\u{F0084}",  // 󰂄
    full: "\u{F0079}",      // 󰁹
    good: "\u{F0082}",      // 󰂂
    half: "\u{F007E}",      // 󰁾
    low: "\u{F007C}",       // 󰁼
    empty: "\u{F007A}",     // 󰁺
    alert: "\u{F0083}",     // 󰂃
  },
  volume: {
    high: "\u{F057E}",      // 󰕾
    medium: "\u{F0580}",    // 󰖀
    low: "\u{F057F}",       // 󰕿
    muted: "\u{F075F}",     // 󰝟
  },
  wifi: {
    strength4: "\u{F0928}", // 󰤨
    strength3: "\u{F0925}", // 󰤥
    strength2: "\u{F0922}", // 󰤢
    strength1: "\u{F091F}", // 󰤟
  },
  bluetooth: "\u{F00AF}",   // 󰂯
  cpu: "\u{F2DB}",           //
  ram: "\u{F035B}",          // 󰍛
  clock: "\u{F0954}",        // 󰥔
  settings: "\u{F0493}",     // 󰒓
  refresh: "\u{F0450}",      // 󰑐
  lock: "\u{F033E}",         // 󰌾
  check: "\u{F012C}",        // 󰄬
  speaker: "\u{F04C3}",      // 󰓃
  weather: "\u{F0590}",      // 󰖐
  monitor: "\u{F0379}",      // 󰍹
}

export function batIcon(pct: number, charging: boolean): string {
  if (charging) return Icons.battery.charging
  if (pct > 90) return Icons.battery.full
  if (pct > 60) return Icons.battery.good
  if (pct > 30) return Icons.battery.half
  if (pct > 10) return Icons.battery.low
  return Icons.battery.alert
}

export function volIcon(vol: number, muted: boolean): string {
  if (muted) return Icons.volume.muted
  if (vol > 0.66) return Icons.volume.high
  if (vol > 0.33) return Icons.volume.medium
  return Icons.volume.low
}

export function wifiIcon(strength: number): string {
  if (strength > 75) return Icons.wifi.strength4
  if (strength > 50) return Icons.wifi.strength3
  if (strength > 25) return Icons.wifi.strength2
  return Icons.wifi.strength1
}
