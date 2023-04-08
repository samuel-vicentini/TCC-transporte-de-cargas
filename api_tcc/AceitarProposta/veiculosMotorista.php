<?php

include('../db.php');

$IDUsuario = $_POST['IDUsuario'];

$sql = "SELECT ID FROM Motorista WHERE IDUsuario = {$IDUsuario}";
$result = mysqli_query($db,$sql);
$r = mysqli_fetch_assoc($result);
$IDMotorista = implode(",", $r);

$result = mysqli_query($db,"SELECT ID, Foto, Descricao from veiculo where IDMotorista = {$IDMotorista}");
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