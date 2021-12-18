# Kakoune
my kakoune config

- .tmux.conf goes on user home
- kakrc goes on .config/kak/



# background_opacity: 1.2
# background_opacity: 1.93
# background_opacity: 0.92
background_opacity: 0.96
# background_opacity: 1.31
window:
  padding:
    x: 8
    y: 0
  dynamic_padding: true
  dimensions:
    columns: 0
    lines: 0
  decorations: full

env:
  TERM: xterm-256color

font:
  normal:
    # family: Cozette Vector
    # family: Hack Nerd Font Mono
    family: Hasklug Nerd Font Mono
    # family: Monoid
    # family: Consolas
    # style: Bold
    # family: Source Code Pro
    # style: Regular
colors:
  name: s3r0 modified
  author: earsplit
  primary:
    # background: "#1F1F1F"
    # background: "#151C1B"
    background: "#161d1c"
    # foreground: "#C0B18B"
    foreground: "#BFC49C"
  cursor:
    text: "#1F1F1F"
    cursor: "#C0B18B"
  normal:
    # black: "#4A3637"
    black: "#161d1c"
    red: "#D17B49"
    green: "#7B8748"
    yellow: "#AF865A"
    blue: "#535C5C"
    magenta: "#775759"
    cyan: "#6D715E"
    white: "#C0B18B"
  bright:
    black: "#4A3637"
    red: "#D17B49"
    green: "#7B8748"
    yellow: "#AF865A"
    blue: "#535C5C"
    magenta: "#775759"
    cyan: "#6D715E"
    white: "#C0B18B"
