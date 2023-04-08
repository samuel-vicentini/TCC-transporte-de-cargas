<?php

include('../db.php');

$IDUsuario = $_POST['IDUsuario'];

$sql = "SELECT ID FROM Cliente WHERE IDUsuario = {$IDUsuario}";
$result = mysqli_query($db,$sql);
$count = mysqli_num_rows($result);
if($count == 1){
    $result = mysqli_query($db,"SELECT c.ID, c.IDUsuario, c.Foto, c.Nome, u.Email as Email, u.Senha as Senha, c.Telefone, c.CPF, c.Estado, c.Cidade, c.Bairro, c.Endereco, c.CEP FROM Cliente c LEFT JOIN usuarios u On u.ID = c.IDUsuario WHERE u.ID = {$IDUsuario} ");
    $count = mysqli_num_rows($result);
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
}else{
    $result = mysqli_query($db,"SELECT m.ID, m.IDUsuario, m.Foto, m.Nome, u.Email as Email, u.Senha as Senha, m.Telefone, m.CPF, m.Estado, m.Cidade, m.Bairro, m.Endereco, m.CEP FROM Motorista m LEFT JOIN usuarios u On u.ID = m.IDUsuario WHERE u.ID = {$IDUsuario} ");
    $count = mysqli_num_rows($result);
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
}
mysqli_close($db);
?>