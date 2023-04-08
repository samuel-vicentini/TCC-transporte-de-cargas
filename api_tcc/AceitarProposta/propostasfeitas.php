<?php

include('../db.php');

if(isset($_POST['TipoProduto']))
{
    $TipoProduto = $_POST["TipoProduto"];
    if($TipoProduto == ""){
        $TipoProduto = "";
    }
}
if(isset($_POST['TipoCarga']))
{
    $TipoCarga = $_POST["TipoCarga"];
    if($TipoCarga == ""){
        $TipoCarga = "";
    }

}
if(isset($_POST['TipoVeiculo']))
{
    $TipoVeiculo = $_POST["TipoVeiculo"];
    if($TipoVeiculo == ""){
        $TipoVeiculo = "";
    }
}
if(isset($_POST['DataRetirada']))
{
    $DataRetirada = $_POST["DataRetirada"];
    if($DataRetirada == "Selecione a data"){
        $DataRetirada = "";
    }
}
if(isset($_POST['DataEntrega']))
{
    $DataEntrega = $_POST["DataEntrega"];
    if($DataEntrega == "Selecione a data"){
        $DataEntrega = "";
    }
}
if(isset($_POST['Origem']))
{
    $Origem = $_POST["Origem"];
    if($Origem == ""){
        $Origem = "";
    }
}
if(isset($_POST['Destino']))
{
    $Destino = $_POST["Destino"];
    if($Destino == ""){
        $Destino = "";
    }
}
if(isset($_POST['Massa']))
{
    $Massa = $_POST["Massa"];
    if($Massa == ""){
        $Massa = "";
    }
}
if(isset($_POST['Unidade']))
{
    $Unidade = $_POST["Unidade"];
    if($Unidade == ""){
        $Unidade = "";
    }
}
if(isset($_POST['Quantidade']))
{
    $Quantidade = $_POST["Quantidade"];
    if($Quantidade == ""){
        $Quantidade = "";
    }
}
if(isset($_POST['TemSeguro']))
{
    $TemSeguro = $_POST["TemSeguro"];
    if($TemSeguro == "false1"){
        $TemSeguro = "";
    }
}
if(isset($_POST['PrecisaSerRefrigerado']))
{
    $PrecisaSerRefrigerado = $_POST["PrecisaSerRefrigerado"];
    if($PrecisaSerRefrigerado == "false1"){
        $PrecisaSerRefrigerado = "";
    }
}
if(isset($_POST['ValorMin']))
{
    $ValorMin = $_POST["ValorMin"];
    if($ValorMin == ""){
        $ValorMin = "";
    }
}

$sql = "SELECT ID, IDCliente, TipoProduto, TipoCarga, TipoVeiculo, Descricao, DataRetirada, DataEntrega, Origem, Destino, Massa, Unidade, Quantidade, TemSeguro, PrecisaSerRefrigerado, Valor  FROM Proposta WHERE 1 = 1 AND Status = 'P' ";
if($TipoProduto != ""){
    $sql = " {$sql} AND TipoProduto = '{$TipoProduto}' ";
}
if($TipoCarga != ""){
    $sql = " {$sql} AND TipoCarga = '{$TipoCarga}' ";
}
if($TipoVeiculo != ""){
    $sql = " {$sql} AND TipoVeiculo = '{$TipoVeiculo}' ";
}
if($DataRetirada != "Selecione a data"){
    $sql = " {$sql} AND DataRetirada LIKE '%{$DataRetirada}%' ";
}
if($DataEntrega != "Selecione a data"){
    $sql = " {$sql} AND DataEntrega LIKE '%{$DataEntrega}%' ";
}
if($Origem != ""){
    $sql = " {$sql} AND Origem LIKE '%{$Origem}%' ";
}
if($Destino != ""){
    $sql = " {$sql} AND Destino LIKE '%{$Destino}%' ";
}
if($Massa != ""){
    $sql = " {$sql} AND Massa LIKE '%{$Massa}%' ";
}
if($Unidade != ""){
    $sql = " {$sql} AND Unidade = '{$Unidade}' ";
}
if($Quantidade != ""){
    $sql = " {$sql} AND Quantidade LIKE '%{$Quantidade}%' ";
}
if($TemSeguro != ""){
    $sql = " {$sql} AND TemSeguro LIKE '%{$TemSeguro}%' ";
}
if($PrecisaSerRefrigerado != ""){
    $sql = " {$sql} AND PrecisaSerRefrigerado LIKE '%{$PrecisaSerRefrigerado}%' ";
}
if($ValorMin != ""){
    $sql = " {$sql} AND Valor LIKE '%{$Valor}%' ";
}

$result = mysqli_query($db,$sql);
if($result)
{
    $rows = array();
    while($r = mysqli_fetch_assoc($result))
    {
        $rows[] = $r;
    }
    echo json_encode($rows);

}else{
    echo json_encode("Erro");
}
mysqli_close($db);
?>
