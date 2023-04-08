<?php

include('../db.php');

$IDFretamento = $_POST['IDFretamento'];
$IDProposta = $_POST['IDProposta'];
$IDVeiculo = $_POST['IDVeiculo'];

$result = mysqli_query($db,"UPDATE `fretamento` SET `IDVeiculo`='{$IDVeiculo}',`Status`='E' WHERE ID = {$IDFretamento}");
if($result){
    $result = mysqli_query($db,"UPDATE `proposta` SET `Status`='E' WHERE ID = {$IDProposta}");
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

mysqli_close($db);
?>