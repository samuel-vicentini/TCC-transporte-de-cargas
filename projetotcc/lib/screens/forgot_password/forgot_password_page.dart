// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, use_build_context_synchronously
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:projetotcc/model/url.dart';
import 'widgets.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({ Key? key }) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {

  final _formKey = GlobalKey<FormState>();
  String? acabouFuncao = 'null';    
  Future<bool> enviarEmail() async{
    print(emailC.text);
    // Aqui precisa mudar o endereço:
    var url = Uri.parse('http://'+localhost+'/api_tcc/EsqueciSenha/enviaremail.php');
    var resposta= await http.post(
      url,
      body: {
        'Email': emailC.text,
      },
    );
    if(resposta.statusCode == 200 && jsonDecode(resposta.body)['Retorno'] == "Success"){
      otp = jsonDecode(resposta.body)['OTP'];
      email = emailC.text;
      print(otp);
      print(email);
      acabouFuncao = 'true';
      return true;
    }else{
      acabouFuncao = 'true';
      return false;
    }
  }
    
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
                      emailC.clear();
                      Navigator.pushReplacementNamed(context, '/screens/login/login_page');
                    }, 
                    icon: Icon(Icons.arrow_back))
              ]),
              Container(width: 150, height: 150, child: Image.asset("assets/cadeado.png")),
              SizedBox(height: 35),
              Text("Esqueci a Senha", textAlign: TextAlign.center, style: TextStyle(fontSize: 40)),
              SizedBox(height: 35),
              Text("Digite o e-mail da sua conta caso você deseje \n trocar a sua senha ", 
              textAlign: TextAlign.center, style: TextStyle(fontSize: 18)),
              SizedBox(height: 35),
              Form(
                key: _formKey,
                child: Container(width: 340, height: 90, child: buildEmail())
              ),
              SizedBox(height: 45),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.grey),
                  borderRadius: BorderRadius.all(Radius.circular(57)),
                  color: Color.fromARGB(255, 0, 140, 255),
                ),
                width: 340,
                height: 50,
                child: TextButton(child: Text('Enviar código', style: TextStyle(color: Colors.black, fontSize: 28)),
                  onPressed: () async{
                    if (!_formKey.currentState!.validate()) {
                      return;
                    } else {
                      bool? deuCerto;
                      do {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Carregando...',textAlign:TextAlign.center, style: TextStyle(fontSize: 22, color: Colors.white)),
                          backgroundColor:Colors.blueAccent,
                        ));
                        deuCerto = await enviarEmail();
                      } while (acabouFuncao == 'null');
                      if(deuCerto == true){
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Código Enviado!',textAlign:TextAlign.center, style: TextStyle(fontSize: 22, color: Colors.white)),
                          backgroundColor:Colors.greenAccent,duration: Duration(milliseconds: 2000),
                        ));
                        emailC.clear();
                        Navigator.pushReplacementNamed(context, '/screens/forgot_password/forgot_password_otp_page');
                      }else{
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Não existe nenhuma conta associada a este e-mail!',textAlign:TextAlign.center, style: TextStyle(fontSize: 22, color: Colors.white)),
                          backgroundColor:Color.fromARGB(255, 245, 82, 82),duration: Duration(milliseconds: 2000),
                        ));
                      }
                    }
                  }
                ),
              ),
            ],
          ),
        ),
      ),
   );
  }
}