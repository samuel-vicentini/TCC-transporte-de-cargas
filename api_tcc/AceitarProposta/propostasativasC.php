<?php

include('../db.php');

$IDUsuario = $_POST['IDUsuario'];

$sql = "SELECT ID FROM Cliente WHERE IDUsuario = {$IDUsuario}";
$result = mysqli_query($db,$sql);
$r = mysqli_fetch_assoc($result);
$IDCliente = implode(",", $r);


$result = mysqli_query($db,"SELECT p.ID as IDProposta, p.IDCliente, m.ID as IDMotorista, f.ID as IDFretamento, m.Foto as FotoMotorista, m.Nome, m.Telefone, u.Email, case WHEN CHAR_LENGTH(v.Foto) > 0 then v.Foto else 'nulo' End as FotoVeiculo, case WHEN v.Descricao is null then 'nulo' else v.Descricao End as DescricaoVeiculo, case WHEN v.Placa is null then 'nulo' else v.Placa End as Placa, case WHEN v.PossuiSeguro is null then 'nulo' else v.PossuiSeguro End as PossuiSeguro, p.TipoProduto, p.TipoCarga, p.TipoVeiculo, p.Descricao as DescricaoProposta, p.DataRetirada, p.DataEntrega, p.Origem, p.Destino, p.Massa, p.Unidade, p.Quantidade, p.TemSeguro, p.PrecisaSerRefrigerado, P.Valor, f.Status  FROM proposta p
inner join fretamento f ON f.IDProposta = p.ID
inner join motorista m ON m.ID = f.IDMotorista
inner join usuarios u ON u.ID = m.IDUsuario
left join veiculo v ON v.ID = f.IDVeiculo
WHERE p.idcliente={$IDCliente} and p.Status !='P' and p.Status !='F' ");
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