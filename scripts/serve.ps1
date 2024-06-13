$env:PHX_SERVER = $True
Set-Location $PSScriptRoot/..
. _build/dev/rel/currency_converter/bin/currency_converter start
