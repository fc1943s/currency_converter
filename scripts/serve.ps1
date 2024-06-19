param($env)


Set-Location $PSScriptRoot/..
$env:PHX_SERVER = $True

$env:SECRET_KEY_BASE = "MM7gtqjtg23SWeeXO3yoFiy9CR0VhLOxX6cHrIMqwgnCiAjRCN7naHSDG56i3TrJ"
. _build/dev/rel/currency_converter/bin/currency_converter start
