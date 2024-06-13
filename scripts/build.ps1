param($fast)

if (!$fast) {
    mix setup

    mix test

    mix assets.deploy
}

mix credo

mix release
