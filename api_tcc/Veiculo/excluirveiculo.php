<?php

include('../db.php');

$IDVeiculo = $_POST['IDVeiculo'];

$result = mysqli_query($db,"DELETE FROM Veiculo WHERE ID = {$IDVeiculo}");
if($result)
{
    echo json_encode("Success");
}
else{
    echo json_encode("Failed");
}

mysqli_close($db);
?>