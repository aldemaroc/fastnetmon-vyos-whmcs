#!/usr/bin/env bash

# Please be carefult! You should not remove cat > 

if [ "$4" = "unban" ]; then

	prefixo="${1%.*}.0/24"
	echo $prefixo
	
	ssh -p 2222 vyos@10.10.0.1 "./unban.sh $prefixo" 


	curl -s --user 'api:key-123' https://api.mailgun.net/v3/aldemaro.com.br/messages -F from='DDoS Guard <monitoramento@aldemaro.com.br>' -F to='aldemaro@aldemaro.com.br' -F subject="Fim de ataque DDoS: $1" -F text="Mitigação removida: IP $1 devido a um ataque com $3 pps" >> /dev/null
    exit 0
fi

if [ "$4" = "ban" ]; then

	detalhes=$( cat )

	prefixo="${1%.*}.0/24"
	echo $prefixo
	
	ssh -p 2222 vyos@10.10.0.1 "./ban.sh $prefixo" 
	
curl -s --user 'api:key-123' https://api.mailgun.net/v3/aldemaro.com.br/messages -F from='DDoS Guard <monitoramento@aldemaro.com.br>' -F to='aldemaro@aldemaro.com.br' -F subject="Alerta de ataque DDoS: $1 devido a um ataque com $3 pps" -F text="Detalhes: $detalhes" >> /dev/null
	
	sleep 10
	curl "http://whmcs.aldemaro.com.br/guardnotify.php?ip=$1"
	echo""
	exit 0
fi

if [ "$4" == "attack_details" ]; then
	detalhes=$( cat )
	sleep 30
	curl -s --user 'api:key-123' https://api.mailgun.net/v3/aldemaro.com.br/messages -F from='DDoS Guard <monitoramento@aldemaro.com.br>' -F to='aldemaro@aldemaro.com.br' -F subject="Informações de ataque DDoS: $1" -F text="Detalhes: $detalhes" >> /dev/null
    exit 0
fi
