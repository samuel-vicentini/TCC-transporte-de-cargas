<?php

include('../db.php');

$Email = $_POST['Email'];
$NovaSenha = $_POST['NovaSenha'];

$sql = "UPDATE `usuarios` SET `Senha`='{$NovaSenha}' WHERE Email = '{$Email}'";
$result = mysqli_query($db,$sql);
if($result){
    echo json_encode("Success");
}
else{
    echo json_encode("Erro");
}

mysqli_close($db);
?>