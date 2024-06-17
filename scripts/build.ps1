param($fast)


mix setup

if (!$fast) {
    ~/.bun/bin/bun install --cwd assets --frozen-lockfile

    mix deps.compile

    mix dialyzer
    mix credo

    mix test
}

$env:MIX_ENV = 'prod'

if (!$fast) {
    mix assets.deploy
}

mix release --overwrite

if (!$fast) {
    mix hex.outdated
}
