<?php

include('../db.php');

$DataImagem = $_POST["DataImagem"];
$NomeImagem = $_POST["NomeImagem"];
$path = "../imageupload_veiculo/$NomeImagem";
$IDVeiculo = $_POST['IDVeiculo'];
$removerFoto = $_POST['FotoAntiga'];

unlink($removerFoto);
$sql = "UPDATE Veiculo SET `Foto`='{$path}' WHERE ID = {$IDVeiculo}";

$result = mysqli_query($db,$sql);
file_put_contents($path, base64_decode($DataImagem));	
if($result){
    $arr = ['Retorno'=>'Success'];
    echo json_encode($arr);    
}
mysqli_close($db);
?>