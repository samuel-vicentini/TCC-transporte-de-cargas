<?php

include('../db.php');

$UsuarioID = $_POST['IDUsuario'];
$TipoProduto = $_POST['TipoProduto'];
$TipoCarga = $_POST['TipoCarga'];
$TipoVeiculo = $_POST['TipoVeiculo'];
$Descricao = $_POST['Descricao'];
$DataRetirada = $_POST['DataRetirada'];
$DataEntrega = $_POST['DataEntrega'];
$Origem = $_POST['Origem'];
$Destino = $_POST['Destino'];
$Massa = $_POST['Massa'];
$Unidade = $_POST['Unidade'];
$Quantidade = $_POST['Quantidade'];
$TemSeguro = $_POST['TemSeguro'];
$PrecisaSerRefrigerado = $_POST['PrecisaSerRefrigerado'];
$Valor = $_POST['Valor'];

$sql = "SELECT c.ID FROM Cliente c LEFT JOIN usuarios u On u.ID = c.IDUsuario WHERE u.ID = {$UsuarioID}";
$result = mysqli_query($db,$sql);
$r = mysqli_fetch_assoc($result);
$IDCliente = implode(",", $r);

$insert = "INSERT INTO `proposta`(`IDCliente`, `TipoProduto`, `TipoCarga`, `TipoVeiculo`, `Descricao`, `DataRetirada`, `DataEntrega`, `Origem`, `Destino`, `Massa`, `Unidade`, `Quantidade`, `TemSeguro`, `PrecisaSerRefrigerado`, `Valor`,`Status`) VALUES ('{$IDCliente}','{$TipoProduto}','{$TipoCarga}','{$TipoVeiculo}','{$Descricao}','{$DataRetirada}','{$DataEntrega}','{$Origem}','{$Destino}','{$Massa}','{$Unidade}','{$Quantidade}','{$TemSeguro}','{$PrecisaSerRefrigerado}','{$Valor}','P')";
$query = mysqli_query($db,$insert);
if($query){
    $arr = ['Retorno'=>'Success'];
    echo json_encode($arr);									
}else{
    $arr = ['Retorno'=>'Erro'];
    echo json_encode($arr);	
}			
mysqli_close($db);
?>