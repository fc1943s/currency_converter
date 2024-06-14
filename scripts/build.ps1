param($fast)

if (!$fast) {
    mix setup

    ~/.bun/bin/bun install --cwd assets --frozen-lockfile

    mix test

    mix assets.deploy
}

mix credo

mix release --overwrite
