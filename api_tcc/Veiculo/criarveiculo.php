<?php

include('../db.php');

$DataImagem =$_POST["DataImagem"];
$NomeImagem =$_POST["NomeImagem"];
$path ="../imageupload_veiculo/$NomeImagem";
$IDUsuario = $_POST['IDUsuario']; 
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
	$sql = "SELECT m.ID FROM Motorista m LEFT JOIN usuarios u On u.ID = m.IDUsuario WHERE u.ID = {$IDUsuario} ";
	$result = mysqli_query($db,$sql);
	$r = mysqli_fetch_assoc($result);
	$IDMotorista = implode(",", $r);
	$insert = "INSERT INTO `veiculo`(`IDMotorista`, `Foto`,`Descricao`, `Placa`, `Modelo`, `Ano`, `PossuiSeguro`, `PossuiRefrigeracao`) VALUES ('{$IDMotorista}','{$path}','{$Descricao}','{$Placa}','{$Modelo}','{$Ano}','{$PossuiSeguro}','{$PossuiRefrigeracao}')";
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