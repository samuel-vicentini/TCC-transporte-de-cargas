<?php

include('../db.php');

$IDUsuario = $_POST['IDUsuario'];

$sql = "SELECT ID FROM Cliente WHERE IDUsuario = {$IDUsuario}";
$result = mysqli_query($db,$sql);
$count = mysqli_num_rows($result);
if($count == 1){
    $result = mysqli_query($db,"DELETE FROM Cliente WHERE IDUsuario = {$IDUsuario}");
    if($result){
        $result = mysqli_query($db,"DELETE FROM Usuarios WHERE ID = {$IDUsuario}");
        if($result)
        {
            echo json_encode("Success");
        }
        else{
            echo json_encode("Erro");
        }
    } else{
        echo json_encode("Erro");
    }
}else{
    $result = mysqli_query($db,"DELETE FROM Motorista WHERE IDUsuario = {$IDUsuario}");
    if($result){
        $result = mysqli_query($db,"DELETE FROM Usuarios WHERE ID = {$IDUsuario}");
        if($result)
        {
            echo json_encode("Success");
        }
        else{
            echo json_encode("Erro");
        }
    } else{
        echo json_encode("Erro");
    }
}
mysqli_close($db);
?>