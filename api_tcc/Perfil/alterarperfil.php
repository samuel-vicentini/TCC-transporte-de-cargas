<?php

include('../db.php');

$Nome = $_POST['Nome'];
$Email = $_POST['Email'];
$Senha = $_POST['Senha'];
$Telefone =$_POST["Telefone"];
$CPF = $_POST['Cpf']; 
$Estado = $_POST['Estado'];
$Cidade = $_POST['Cidade'];
$Bairro = $_POST['Bairro'];
$Endereco = $_POST['Endereco'];
$CEP = $_POST["Cep"];
$IDUsuario = $_POST['IDUsuario'];
$MesmoEmail = $_POST['MesmoEmail'];

$sql = "SELECT Email FROM Usuarios WHERE Email = '{$Email}'";
$result = mysqli_query($db,$sql);
$count = mysqli_num_rows($result);
if($count == 1 && $MesmoEmail == "false"){
	$arr = ['Retorno'=>'Ja existe esse email'];
	echo json_encode($arr);	
}
else{
    $result = mysqli_query($db,"SELECT c.ID FROM Cliente c LEFT JOIN usuarios u On u.ID = c.IDUsuario WHERE u.ID = {$IDUsuario}");
    $count = mysqli_num_rows($result);
    if($count >= 1){
        $updateUser = "UPDATE `usuarios` SET `Nome`='{$Nome}',`Email`='{$Email}',`Senha`='{$Senha}' WHERE ID = {$IDUsuario}";
        $query = mysqli_query($db,$updateUser);
        if($query){
            $updateCliente = "UPDATE `cliente` SET `Nome`='{$Nome}',`Telefone`='{$Telefone}',`CPF`='{$CPF}',`Estado`='{$Estado}',`Cidade`='{$Cidade}',`Bairro`='{$Bairro}',`Endereco`='{$Endereco}',`CEP`='{$CEP}' WHERE IDUsuario = {$IDUsuario}";
            $query = mysqli_query($db,$updateCliente);
            if($query){
                $arr = ['Retorno'=>'Success'];
                echo json_encode($arr);									
            }else{
                $arr = ['Retorno'=>'Erro cli'];
                echo json_encode($arr);	
            }    
        }else{
            $arr = ['Retorno'=>'Erro User'];
            echo json_encode($arr);	   
        }
    }else {
        $updateUser = "UPDATE `usuarios` SET `Nome`='{$Nome}',`Email`='{$Email}',`Senha`='{$Senha}' WHERE ID = {$IDUsuario}";
        $query = mysqli_query($db,$updateUser);
        if($query){
            $updateMotorista = "UPDATE `motorista` SET `Nome`='{$Nome}',`Telefone`='{$Telefone}',`CPF`='{$CPF}',`Estado`='{$Estado}',`Cidade`='{$Cidade}',`Bairro`='{$Bairro}',`Endereco`='{$Endereco}',`CEP`='{$CEP}' WHERE IDUsuario = {$IDUsuario}";
            $query = mysqli_query($db,$updateMotorista);
            if($query){
                $arr = ['Retorno'=>'Success'];
                echo json_encode($arr);									
            }else{
                $arr = ['Retorno'=>'Erro moto'];
                echo json_encode($arr);	
            }    
        }else{
            $arr = ['Retorno'=>'Erro User'];
            echo json_encode($arr);	   
        }    
    }
}
mysqli_close($db);
?>