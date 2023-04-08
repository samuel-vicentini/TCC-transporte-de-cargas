// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, use_build_context_synchronously
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:projetotcc/model/url.dart';
import 'package:projetotcc/screens/homeCliente/home_cliente_page.dart';
import 'package:projetotcc/services/VerificarToken.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}
 
class _LoginPageState extends State<LoginPage> {

  final _formKey = GlobalKey<FormState>();
  final emailC = TextEditingController();
  final senhaC = TextEditingController();
  String? perfil;
    
  Future<bool> login() async{
    SharedPreferences sharedPreferences= await SharedPreferences.getInstance();
    // Aqui precisa mudar o endereço:
    var url = Uri.parse('http://'+localhost+'/api_tcc/Login/login.php');
    var resposta= await http.post(
        url,
        body: {
          'Email': emailC.text,
          'Senha': senhaC.text,
        },
    );
    if(resposta.statusCode == 200 && jsonDecode(resposta.body)['Retorno'] == "Success"){
      var user = jsonDecode(resposta.body)['Dados'];
      perfil = user['Perfil'];
      idUsuario = user['ID'];
      await sharedPreferences.setString('token', "${jsonDecode(resposta.body)['token']+perfil+idUsuario}");
      return true;
    }else{
      return false;
    }
  }

  limparCampos(){
    setState(() {
      emailC.clear();  
      senhaC.clear();   
    });
  }

  bool _isVisible = false;
  void updateStatus() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(width: 170, height: 170,child: Image.asset('assets/caminhao.jpg')),
              SizedBox(height: 10),
              Text("Login",style: TextStyle(fontSize: 36,)),
              SizedBox(height: 40),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Container(width: 340,  height: 90,
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: "E-mail", 
                        labelStyle: TextStyle(color: Color.fromARGB(255, 88, 88, 88)),
                        hintText: "Digite seu e-mail",
                        prefixIcon: Icon(Icons.email, color: Color.fromARGB(255, 88, 88, 88),size: 19),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(22)),
                            borderSide: BorderSide(color: Color.fromARGB(255, 88, 88, 88)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(22)),
                          borderSide: BorderSide(color: Color.fromARGB(255, 88, 88, 88)),
                        ),
                      ),
                      controller: emailC,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'O campo e-mail é obrigatório!';
                        }
                        if (!RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                            .hasMatch(value)) {
                          return 'Por favor digite um e-mail válido';
                        }
                        return null;
                      },
                    )                 
                    ),
                    Container(width: 340,  height: 81,
                    child: TextFormField(
                      obscureText: _isVisible ? false : true,
                      decoration:  InputDecoration(
                        labelText: "Senha",
                        labelStyle: TextStyle(color: Color.fromARGB(255, 88, 88, 88)),
                        hintText: "Digite sua senha",
                        prefixIcon: const Icon(Icons.lock, color: Color.fromARGB(255, 88, 88, 88),size: 19),
                        suffixIcon: IconButton(
                          onPressed: () => updateStatus(),
                          icon: Icon(_isVisible ? Icons.visibility : Icons.visibility_off),
                          iconSize: 19,
                          color: Color.fromARGB(255, 88, 88, 88),
                        ),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(22)),
                          borderSide: BorderSide(color: Color.fromARGB(255, 88, 88, 88)),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(22)),
                          borderSide: BorderSide(color: Color.fromARGB(255, 88, 88, 88)),
                        ),
                      ),
                      controller: senhaC,
                      keyboardType: TextInputType.visiblePassword,
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return 'O campo senha é obrigatório!';
                        }
                        return null;
                      },
                      )
                    ),
                  ],
                )
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    child: Text("Esqueci minha senha", style: TextStyle(fontSize: 17)),
                    onPressed: () {
                      limparCampos();
                      Navigator.pushReplacementNamed(context, '/screens/forgot_password/forgot_password_page');
                    },
                  ),
                  SizedBox(width: 40)
                ],
              ),
              SizedBox(height: 30),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.grey),
                  borderRadius: BorderRadius.all(Radius.circular(57)),
                  color: Color.fromARGB(255, 0, 140, 255),
                ),
                width: 340,
                height: 50,
                child: TextButton(
                  child: const Text(
                    'Entrar',
                    style: TextStyle(color: Colors.black, fontSize: 28),
                  ),
                  onPressed: () async{
                    if (!_formKey.currentState!.validate()) {
                      return;
                    } else {
                      FocusScopeNode currentFocus=FocusScope.of(context);
                      bool deuCerto=await login();
                      if(!currentFocus.hasPrimaryFocus){
                        currentFocus.unfocus();
                      }
                      if(deuCerto){
                        indexglobal = 0;
                        if(perfil == "M"){
                          limparCampos();
                          Navigator.pushNamedAndRemoveUntil(context, '/screens/homeMotorista/home_motorista_page', (route) => false);
                        }else{
                          limparCampos();
                          Navigator.pushNamedAndRemoveUntil(context, '/screens/homeCliente/home_cliente_page', (route) => false);
                        }
                      }else{
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('E-mail ou Senha são inválidos!',textAlign:TextAlign.center, style: TextStyle(fontSize: 20, color: Colors.white)),
                          backgroundColor:Color.fromARGB(255, 245, 82, 82),duration: Duration(milliseconds: 2500),
                        )); 
                      }
                    }
                  }
                ),
              ),
              SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Não possui uma conta?", style: TextStyle(fontSize: 17)),
                  TextButton(
                    child: const Text("Cadastre-se agora!", style: TextStyle(fontSize: 17)),
                    onPressed: () {
                      limparCampos();
                      Navigator.pushNamed(context, '/screens/register/register_page');
                    },
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}