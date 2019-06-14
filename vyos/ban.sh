#!/bin/vbash

bloco=$1

echo "Banindo prefixo $bloco"

source /opt/vyatta/etc/functions/script-template

configure

testaprefixo=$(show policy prefix-list BLOCK-DDOS | grep $bloco)

if [ -z "$testaprefixo" ] 
then
	regra=$(show policy prefix-list BLOCK-DDOS | grep rule | tail -1 | tail -c 4 | head -c 1)

	if [ -z "$regra" ] 
	then
		numregra="1"
	else	
		numregra=$(($regra +1))
	fi
	
	set policy prefix-list BLOCK-DDOS rule $numregra action permit
	set policy prefix-list BLOCK-DDOS rule $numregra prefix $bloco

	commit
	echo "Prefixo $bloco desanunciado"
else
echo "Prefixo $bloco banido!"
fi
