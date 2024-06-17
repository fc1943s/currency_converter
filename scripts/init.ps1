mix do local.rebar --force, local.hex --force
mix escript.install github livebook-dev/livebook --force

curl -fsSL https://bun.sh/install | bash
$env:PATH = "~/.bun/bin:$env:PATH"

if ($IsLinux) {
    sudo apt update
    sudo apt install -y inotify-tools
}
