<?php
require_once("init.php");
use WHMCS\Database\Capsule;

//IP do servidor que vai chamar o script por curl
$ippermitido="192.168.0.1";

$ip=$_GET[ip];

//Pega o IP de quem está fazendo a requisição. Funciona com ou sem cloudflare e proxy
if(!empty($_SERVER['HTTP_CLIENT_IP'])){
        $ipremoto = $_SERVER['HTTP_CLIENT_IP'];
    }elseif(!empty($_SERVER['HTTP_X_FORWARDED_FOR'])){
        $ipremoto = $_SERVER['HTTP_X_FORWARDED_FOR'];
    }else{
        $ipremoto = $_SERVER['REMOTE_ADDR'];
    }

// Verifica se temos um IP em GET
if (!empty($ip)) {
	
	// Segurança mínima: verificar se o IP chamando o script é autorizado
	if($ippermitido==$ipremoto){
		
		// Pega o IP e procura pelo ID do produto na database
		$id=mysql_fetch_array(mysql_query("SELECT * FROM  `tblhosting` WHERE  `dedicatedip` LIKE  '".$ip."'"));
		
		// Se o produto existir, envia o email
		if (!empty($id)) {
			$command = 'SendEmail';
			$postData = array(
				'messagename' => 'Alerta de ataque DDoS',
				'id' => $id[id],

			);
			$results = localAPI($command, $postData, $adminUsername);
			echo 'Alerta enviado para cliente com sucesso';
		}
	}
}
?>
