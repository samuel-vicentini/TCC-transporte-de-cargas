<?php

include('../db.php');

$DataImagem =$_POST["DataImagem"];
$NomeImagem =$_POST["NomeImagem"];
$path ="../imageupload/$NomeImagem";
$IDUsuario = $_POST['IDUsuario'];
$removerFoto = $_POST['FotoAntiga'];

$sql = "SELECT ID FROM Cliente WHERE IDUsuario = {$IDUsuario}";
$result = mysqli_query($db,$sql);
$count = mysqli_num_rows($result);
if($count == 1){
    unlink($removerFoto);
    $sql = "UPDATE Cliente SET `Foto`='{$path}' WHERE IDUsuario = {$IDUsuario}";
    $result = mysqli_query($db,$sql);
    file_put_contents($path, base64_decode($DataImagem));	
    if($result){
        $arr = ['Retorno'=>'Success'];
        echo json_encode($arr);    
    }
}
else{
    unlink($removerFoto);
	$sql = "UPDATE Motorista SET `Foto`='{$path}' WHERE IDUsuario = {$IDUsuario}";
    $result = mysqli_query($db,$sql);
    file_put_contents($path, base64_decode($DataImagem));	
    if($result){
        $arr = ['Retorno'=>'Success'];
        echo json_encode($arr);    
    }
}
mysqli_close($db);
?>