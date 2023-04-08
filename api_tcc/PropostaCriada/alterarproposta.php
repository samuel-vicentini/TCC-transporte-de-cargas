<?php

include('../db.php');

$IDProposta = $_POST['IDProposta'];
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

$result = mysqli_query($db,"UPDATE `proposta` SET `TipoProduto`='{$TipoProduto}',`TipoCarga`='{$TipoCarga}',`TipoVeiculo`='{$TipoVeiculo}',`Descricao`='{$Descricao}',`DataRetirada`='{$DataRetirada}',`DataEntrega`='{$DataEntrega}',`Origem`='{$Origem}',`Destino`='{$Destino}',`Massa`='{$Massa}',`Unidade`='{$Unidade}',`Quantidade`='{$Quantidade}',`TemSeguro`='{$TemSeguro}',`PrecisaSerRefrigerado`='{$PrecisaSerRefrigerado}',`Valor`='{$Valor}' WHERE ID = $IDProposta");
if($result)
{
    echo json_encode("Success");
}
else{
    echo json_encode("Erro");
}

mysqli_close($db);
?>