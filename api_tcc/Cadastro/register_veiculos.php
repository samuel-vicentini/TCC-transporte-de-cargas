<?php

include('../db.php');

if(isset($_POST['DataImagem']))
{
    $DataImagem =$_POST["DataImagem"];
}
if(isset($_POST['NomeImagem']))
{
    $NomeImagem =$_POST["NomeImagem"];
}
$path ="../imageupload_veiculo/$NomeImagem";
$MotoristaID = $_POST['IDMotorista']; 
$Descricao = $_POST['Descricao']; 
$Placa = $_POST['Placa']; 
$Modelo = $_POST['Modelo']; 
$Ano = $_POST['Ano']; 
$PossuiSeguro = $_POST['PossuiSeguro']; 
$PossuiRefrigeracao = $_POST['PossuiRefrigeracao']; 

$sql = "SELECT Placa FROM Veiculo WHERE Placa = '{$Placa}'";
$result = mysqli_query($db,$sql);
$count = mysqli_num_rows($result);
if($count == 1){
	$arr = ['Retorno'=>'Placa repetida'];
	echo json_encode($arr);	
}
else{
	$insert = "INSERT INTO `veiculo`(`IDMotorista`, `Foto`,`Descricao`, `Placa`, `Modelo`, `Ano`, `PossuiSeguro`, `PossuiRefrigeracao`) VALUES ('{$MotoristaID}','{$path}','{$Descricao}','{$Placa}','{$Modelo}','{$Ano}','{$PossuiSeguro}','{$PossuiRefrigeracao}')";
	file_put_contents($path, base64_decode($DataImagem));
	$query = mysqli_query($db,$insert);
	if($query){
		$last_id = mysqli_insert_id($db);
		$arr = ['Retorno'=>'Success',];
		echo json_encode($arr);									
	}else{
		$arr = ['Retorno'=>'Erro'];
		echo json_encode($arr);	
	}
}

mysqli_close($db);
?>