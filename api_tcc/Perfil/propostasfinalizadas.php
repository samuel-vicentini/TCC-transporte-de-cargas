<?php

include('../db.php');

$IDUsuario = $_POST['IDUsuario'];

$sql = "SELECT ID FROM Cliente WHERE IDUsuario = {$IDUsuario}";
$result = mysqli_query($db,$sql);
$count = mysqli_num_rows($result);
if($count == 1){
    $sql = "SELECT ID FROM Cliente WHERE IDUsuario = {$IDUsuario}";
    $result = mysqli_query($db,$sql);
    $r = mysqli_fetch_assoc($result);
    $IDCliente = implode(",", $r);

    $result = mysqli_query($db,"SELECT p.*, DATE_FORMAT(f.DataAceita, '%d/%m/%Y %H:%i:%s') as DataAceita, DATE_FORMAT(f.DataFinal, '%d/%m/%Y %H:%i:%s') as DataFinal, m.Foto, m.Nome, m.Telefone, u.Email FROM Proposta p INNER JOIN fretamento f On f.IDProposta = p.ID INNER JOIN motorista m ON m.ID = f.IDMotorista INNER JOIN usuarios u ON u.ID = m.IDUsuario WHERE p.IDCliente = {$IDCliente} AND p.Status = 'F';");
    $count = mysqli_num_rows($result);
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
}else{
    $sql = "SELECT ID FROM Motorista WHERE IDUsuario = {$IDUsuario}";
    $result = mysqli_query($db,$sql);
    $r = mysqli_fetch_assoc($result);
    $IDMotorista = implode(",", $r);

    $result = mysqli_query($db,"SELECT p.*,  DATE_FORMAT(f.DataAceita, '%d/%m/%Y %H:%i:%s') as DataAceita, DATE_FORMAT(f.DataFinal, '%d/%m/%Y %H:%i:%s') as DataFinal, c.Foto, c.Nome, c.Telefone, u.Email FROM Fretamento f
    INNER JOIN proposta p On p.ID = f.IDProposta
    INNER JOIN cliente c ON c.ID = p.IDCliente 
    INNER JOIN usuarios u ON u.ID = c.IDUsuario
    WHERE f.IDMotorista = {$IDMotorista} AND p.Status = 'F';");
    $count = mysqli_num_rows($result);
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
}
mysqli_close($db);
?>