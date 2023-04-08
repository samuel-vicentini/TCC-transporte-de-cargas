<?php

include('../db.php');

$UsuarioID = $_POST['IDUsuario'];

$sql = "SELECT c.ID FROM Cliente c LEFT JOIN usuarios u On u.ID = c.IDUsuario WHERE u.ID = {$UsuarioID} ";
$result = mysqli_query($db,$sql);
$r = mysqli_fetch_assoc($result);
$IDCliente = implode(",", $r);

$result = mysqli_query($db,"SELECT * FROM Proposta WHERE IDCliente = {$IDCliente} AND Status = 'P' ");
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