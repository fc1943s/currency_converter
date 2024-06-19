param($fast)


mix setup

if (!$fast) {
    ~/.bun/bin/bun install --cwd assets --frozen-lockfile

    mix deps.compile

    mix dialyzer
    mix credo

    mix test
}

if (!$fast) {
    mix assets.deploy
}

mix release --overwrite

if (!$fast) {
    pwsh test/e2e/run.ps1

    mix hex.outdated
}
