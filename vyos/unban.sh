#!/bin/vbash

bloco=$1

echo "Desbanindo prefixo $bloco"

source /opt/vyatta/etc/functions/script-template

configure


regra=$(sh policy prefix-list BLOCK-DDOS | grep -B3 $bloco | grep "rule" | tail -c 4 | head -c 1)

del policy prefix-list BLOCK-DDOS rule $regra


commit
echo "Prefixo $bloco desbanido"
