import app from "ags/gtk4/app"
import style from "./style.scss"
import Bar from "./bar/Bar"

const monitors = [0, 1]

app.start({
  css: style,
  main() {
    monitors.forEach((monitor) => Bar(monitor))
  },
})
