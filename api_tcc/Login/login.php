<?php

include('../db.php');

$Email = $_POST['Email'];
$Senha = $_POST['Senha'];

$sql = "SELECT u.ID, u.Nome, case when c.ID is not NULL Then 'C' else 'M' END as 'Perfil'  FROM Usuarios u 
LEFT JOIN cliente c On c.IDUsuario = u.ID
LEFT JOIN motorista m On m.IDUsuario = u.ID
WHERE u.Email = '{$Email}' AND u.Senha = '{$Senha}'";

$result = mysqli_query($db,$sql);
$count = mysqli_num_rows($result);
if($count == 1){
    $rows = array();
    while($r = mysqli_fetch_assoc($result))
    {
        $rows['Dados'] = $r;
    }
    $token = md5(uniqid(mt_rand(),true));
    $arr = ['Retorno'=>'Success','token'=>$token];
    echo json_encode(array_merge($arr,$rows));

}else{
    $arr = ['Retorno'=>'Erro'];
    echo json_encode($arr);
}
mysqli_close($db);
?>