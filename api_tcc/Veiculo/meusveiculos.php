<?php

include('../db.php');

$UsuarioID = $_POST['IDUsuario'];

$sql = "SELECT m.ID FROM Motorista m LEFT JOIN usuarios u On u.ID = m.IDUsuario WHERE u.ID = {$UsuarioID} ";
$result = mysqli_query($db,$sql);
$r = mysqli_fetch_assoc($result);
$IDMotorista = implode(",", $r);

$result = mysqli_query($db,"SELECT * FROM Veiculo WHERE IDMotorista = {$IDMotorista}");
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