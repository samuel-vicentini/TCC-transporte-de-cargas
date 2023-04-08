// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import 'widgets.dart';

class ForgotPasswordOTPPage extends StatefulWidget {

  const ForgotPasswordOTPPage({ Key? key }) : super(key: key);

  @override
  State<ForgotPasswordOTPPage> createState() => _ForgotPasswordOTPPageState();
}

class _ForgotPasswordOTPPageState extends State<ForgotPasswordOTPPage> {

  String? codigoDigitado;
  OtpFieldController otpController = OtpFieldController();

  @override
  Widget build(BuildContext context) {
  return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            children: [
              Row(children: [
                  IconButton(
                    onPressed: (){
                      Navigator.pushReplacementNamed(context, '/screens/forgot_password/forgot_password_page');
                    }, 
                    icon: Icon(Icons.arrow_back)),
              ]),
              SizedBox(width: 150, height: 150,child: Image.asset("assets/cadeado_otp.png")),
              SizedBox(height: 35),
              Text("Verificação", textAlign: TextAlign.center, style: TextStyle(fontSize: 40)),
              SizedBox(height: 30),
              Text('Digite o código enviado para:',textAlign: TextAlign.center, style: TextStyle(fontSize: 18)),
              SizedBox(height: 5),
              Text(email!, textAlign: TextAlign.center, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 40),
              OTPTextField(
                controller: otpController,
                keyboardType: TextInputType.number,
                length: 4,
                fieldWidth: 50,
                width: 340,
                textFieldAlignment: MainAxisAlignment.spaceAround,
                fieldStyle: FieldStyle.box,
                otpFieldStyle: OtpFieldStyle(
                  borderColor:  Color.fromARGB(255, 88, 88, 88),
                  enabledBorderColor:  Color.fromARGB(255, 88, 88, 88),
                  focusBorderColor:  Color.fromARGB(255, 88, 88, 88),
                ),
                onChanged: (String? value){},
                onCompleted: (String? value){
                  codigoDigitado = value;
                  if (codigoDigitado == null || codigoDigitado!.length < 4){
                    codigoDigitado = "";
                    otpController.clear();
                    otpController.setFocus(1);
                    ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:Text('Digite um valor válido!',textAlign:TextAlign.center),
                      backgroundColor:Colors.redAccent,
                    ));
                  }else{
                    if(codigoDigitado == otp){
                      Navigator.pushReplacementNamed(context, '/screens/forgot_password/forgot_password_change_page');     
                    }else{
                      otpController.clear();
                      ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:Text('Código Incorreto!',textAlign:TextAlign.center),
                        duration: Duration(milliseconds: 1000),
                        backgroundColor:Colors.redAccent,
                      ));  
                    }
                  }
                },
              ),
              SizedBox(height: 55),
              Text("Não recebeu nenhum código?", style: TextStyle(fontSize: 17)),
              TextButton(
                child: const Text("Enviar Novo Código", style: TextStyle(fontSize: 17)),
                onPressed: (){
                  Navigator.pushReplacementNamed(context, '/screens/forgot_password/forgot_password_page');
                }
              )
            ],
          ),
        ),
      ),
    );
  }
}



