<?php

include('../db.php');
use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;

$Email = $_POST['Email'];

$sql = "SELECT Email FROM Usuarios WHERE Email = '".$Email."'";
$result = mysqli_query($db,$sql);
$count = mysqli_num_rows($result);
if($count != 1){
	$arr = ['Retorno'=>'Erro'];
    echo json_encode($arr);
}else{
    function generateNumericOTP($n) {
        $generator = "1357902468";
        $result = "";
        for ($i = 1; $i <= $n; $i++) {
            $result .= substr($generator, (rand()%(strlen($generator))), 1);
        }
        return $result;
    }
    $n = 4;
    $otp = generateNumericOTP($n);

    require 'src/Exception.php';
    require 'src/PHPMailer.php';
    require 'src/SMTP.php';

    $mail = new PHPMailer;
    // informações foram retiradas por segurança!
    $mail->isSMTP();                      // Set mailer to use SMTP
    $mail->Host = 'smtp.gmail.com';       // Specify main and backup SMTP servers
    $mail->SMTPAuth = true;               // Enable SMTP authentication
    $mail->Username = '';   // SMTP username
    $mail->Password = '';   // SMTP password
    $mail->SMTPSecure = 'tls';            // Enable TLS encryption, `ssl` also accepted
    $mail->Port = '';                    // TCP port to connect to

    // Sender info
    $mail->setFrom(address:'', name: '');

    // pessoa que vai receber o código:
    $mail->addAddress($Email);

    // Set email format to HTML
    $mail->isHTML(true);

    // Mail subject
    $mail->Subject = 'Transporte de Cargas';

    // Mail body content
    $bodyContent = '<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <title></title>
    </head>
    <body>
        <div style="margin-left: 20px; color: #123456;font-size: 20pt; font-weight: bold;font-family:Calibri;">
            Código de Verificação!
        </div>
        <div style="margin-top: 20px; margin-left: 20px; color: #123456;font-size: 16pt; font-weight: bold;font-family:Calibri;">
            Digite o código abaixo no seu aplicativo para prosseguir e alterar a sua senha:<br>
            <h2>'.$otp.'</h2>            
        </div>
    </body>
    </html>
    ';

    $mail->Body = $bodyContent;

    if(!$mail->send()) { 
        //echo 'Message could not be sent. Mailer Error: '.$mail->ErrorInfo; 
        $arr = ['Retorno'=>'Erro'];
        echo json_encode($arr);
    } else { 
        $arr = ['Retorno'=>'Success','OTP'=>$otp];
        echo json_encode($arr);
    } 
}
mysqli_close($db);
?>
