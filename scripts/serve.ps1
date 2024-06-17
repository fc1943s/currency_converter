$env:PHX_SERVER = $True
Set-Location $PSScriptRoot/..
. _build/prod/rel/currency_converter/bin/currency_converter start
