$ErrorActionPreference = 'Stop'

mix do local.rebar --force, local.hex --force
mix escript.install github livebook-dev/livebook --force

curl -fsSL https://bun.sh/install | bash
$env:PATH = "~/.bun/bin:$env:PATH"

~/.bun/bin/bunx --bun playwright@1.44.0 install

if ($IsLinux) {
    sudo apt update
    sudo apt install -y inotify-tools
}
