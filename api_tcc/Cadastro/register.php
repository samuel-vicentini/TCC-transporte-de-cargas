<?php

include('../db.php');

$Nome = $_POST['Nome'];
$Email = $_POST['Email'];
$Senha = $_POST['Senha'];
if(isset($_POST['DataImagem']))
{
    $DataImagem =$_POST["DataImagem"];
}
if(isset($_POST['NomeImagem']))
{
    $NomeImagem =$_POST["NomeImagem"];
}
$path ="../imageupload/$NomeImagem";
$Telefone =$_POST["Telefone"];
$Cpf = $_POST['Cpf']; 
$Estado = $_POST['Estado'];
$Cidade = $_POST['Cidade'];
$Bairro = $_POST['Bairro'];
$Endereco = $_POST['Endereco'];
if(isset($_POST['Cep']))
{
    $Cep =$_POST["Cep"];
}
$GroupValue = $_POST['GroupValue'];

$sql = "SELECT Email FROM Usuarios WHERE Email = '{$Email}'";
$result = mysqli_query($db,$sql);
$count = mysqli_num_rows($result);

if($count == 1){
	$arr = ['Retorno'=>'Ja existe esse email'];
	echo json_encode($arr);	
}
else{
	$insertUser = "INSERT INTO Usuarios (`Nome`, `Email`, `Senha`) 
	VALUES ('{$Nome}','{$Email}','{$Senha}')";
	$query = mysqli_query($db,$insertUser);
	$last_id = mysqli_insert_id($db);
	if($query){
		if($GroupValue == "Cliente"){
			$insertCliente = "INSERT INTO Cliente (`IDUsuario`, `Foto`, `Nome`, `Telefone`, `CPF`, `Estado`, `Cidade`, `Bairro`, `Endereco`, `CEP`) VALUES ('{$last_id}','{$path}','{$Nome}','{$Telefone}','{$Cpf}','{$Estado}','{$Cidade}','{$Bairro}','{$Endereco}','{$Cep}')";
			file_put_contents($path, base64_decode($DataImagem));
			$query = mysqli_query($db,$insertCliente);
			if($query){
				$last_id = mysqli_insert_id($db);
				$arr = ['Retorno'=>'Success'];
				echo json_encode($arr);									
	     	}else{
				$arr = ['Retorno'=>'Erro cli'];
				echo json_encode($arr);	
			}
		}else{
			$insertMotorista = "INSERT INTO Motorista (`IDUsuario`, `Foto`, `Nome`, `Telefone`, `CPF`, `Estado`, `Cidade`, `Bairro`, `Endereco`, `CEP`) VALUES ('{$last_id}','{$path}','{$Nome}','{$Telefone}','{$Cpf}','{$Estado}','{$Cidade}','{$Bairro}','{$Endereco}','{$Cep}')";
			file_put_contents($path, base64_decode($DataImagem));
			$query = mysqli_query($db,$insertMotorista);
			if($query){
				$last_id = mysqli_insert_id($db);
				$arr = ['Retorno'=>'Success','MotoristaID'=>$last_id];
				echo json_encode($arr);
			}else{
				$arr = ['Retorno'=>'Erro moto'];
				echo json_encode($arr);	
			}	
		}
	}else{
		$arr = ['Retorno'=>'Erro user'];
		echo json_encode($arr);	
	}
}
mysqli_close($db);
?>