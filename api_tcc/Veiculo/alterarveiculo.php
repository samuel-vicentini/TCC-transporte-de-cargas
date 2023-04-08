<?php

include('../db.php');

$IDVeiculo = $_POST['IDVeiculo'];
$Descricao = $_POST['Descricao'];
$Placa = $_POST['Placa'];
$Modelo = $_POST['Modelo'];
$Ano = $_POST['Ano'];
$PossuiSeguro = $_POST['PossuiSeguro'];
$PossuiRefrigeracao = $_POST['PossuiRefrigeracao'];
$mesmaPlaca = $_POST['mesmaPlaca'];

$sql = "SELECT Placa FROM Veiculo WHERE Placa = '{$Placa}'";
$result = mysqli_query($db,$sql);
$count = mysqli_num_rows($result);
if($count == 1 && $mesmaPlaca == "false"){
    $arr = ['Retorno'=>'Placa Repetida'];
	echo json_encode($arr);	
}
else{
    $result = mysqli_query($db,"UPDATE `veiculo` SET `Descricao`='{$Descricao}',`Placa`='{$Placa}',`Modelo`='{$Modelo}',`Ano`='{$Ano}',`PossuiSeguro`='{$PossuiSeguro}',`PossuiRefrigeracao`='{$PossuiRefrigeracao}' WHERE ID = {$IDVeiculo}");
    if($result){
        $arr = ['Retorno'=>'Success'];
        echo json_encode($arr);									
    }else{
        $arr = ['Retorno'=>'Erro'];
        echo json_encode($arr);	
    }    
}
mysqli_close($db);
?>