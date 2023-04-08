<?php

include('../db.php');

$IDProposta = $_POST['IDProposta'];

$result = mysqli_query($db,"DELETE FROM Proposta WHERE ID = {$IDProposta}");
if($result)
{
    echo json_encode("Success");
}
else{
    echo json_encode("Failed");
}

mysqli_close($db);
?>