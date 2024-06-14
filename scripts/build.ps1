param($fast)

if (!$fast) {
    mix setup

    mix test

    mix assets.deploy

    bun install --cwd assets --frozen-lockfile
}

mix credo

mix release --overwrite
