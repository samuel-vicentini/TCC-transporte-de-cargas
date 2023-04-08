<?php

include('../db.php');

$IDFretamento = $_POST['IDFretamento'];
$IDProposta = $_POST['IDProposta'];

$result = mysqli_query($db,"DELETE FROM Fretamento WHERE ID = {$IDFretamento}");
if($result){
    $result = mysqli_query($db,"UPDATE `proposta` SET `Status`='P' WHERE ID = {$IDProposta}");
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