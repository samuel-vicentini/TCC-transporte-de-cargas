<?php

include('../db.php');

$IDUsuario = $_POST['IDUsuario'];
$IDCliente = $_POST['IDCliente'];
$IDProposta = $_POST['IDProposta'];

$sql = "SELECT ID FROM Motorista WHERE IDUsuario = {$IDUsuario}";
$result = mysqli_query($db,$sql);
$r = mysqli_fetch_assoc($result);
$IDMotorista = implode(",", $r);

$sql = "SELECT ID FROM Fretamento WHERE IDMotorista = '{$IDMotorista}' AND Status <> 'F'";
$result = mysqli_query($db,$sql);
$count = mysqli_num_rows($result);
if($count > 0){
	$retorno = 'Ja tem proposta ativa';
	echo json_encode($retorno);	
}
else{
    $result = mysqli_query($db,"UPDATE `proposta` SET `Status`= 'A' WHERE ID = $IDProposta");
    if($result)
    {
        $insert = "INSERT INTO `fretamento`(`IDProposta`, `IDMotorista`, `Status`) 
        VALUES ('{$IDProposta}','{$IDMotorista}','A')";
        $query = mysqli_query($db,$insert);
        if($query){
            $retorno = 'Success';
            echo json_encode($retorno);									
        }else{
            $retorno = 'Erro';
            echo json_encode($retorno);		
        }		

    }
    else{
        echo json_encode("Erro");
    }
}

mysqli_close($db);
?>