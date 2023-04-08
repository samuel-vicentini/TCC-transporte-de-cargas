// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, use_build_context_synchronously
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:projetotcc/model/url.dart';
import 'widgets.dart';
import 'package:http/http.dart' as http;
 
class ForgotPasswordChangePage extends StatefulWidget {
  const ForgotPasswordChangePage({ Key? key }) : super(key: key);

  @override
  State<ForgotPasswordChangePage> createState() => _ForgotPasswordChangePageState();
}

class _ForgotPasswordChangePageState extends State<ForgotPasswordChangePage> {

  final _formKey = GlobalKey<FormState>();

  Future<bool> trocarSenha() async{
    // Aqui precisa mudar o endereço:
    var url=Uri.parse('http://'+localhost+'/api_tcc/EsqueciSenha/trocarsenha.php');
    var resposta= await http.post(
        url,
        body: {
          'Email': email,
          'NovaSenha': senhaC.text,
        },
    );
    if(resposta.statusCode == 200 && jsonDecode(resposta.body) == "Success"){
      return true;
    }else{
      return false;
    }
  }

  bool _isVisible = false;
  void updateStatus() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }
  
  bool _isVisible2 = false;
  void updateStatus2() {
    setState(() {
      _isVisible2 = !_isVisible2;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            children: [
              SizedBox(height: 25),
              Container(width: 180, height: 180, child: Image.asset("assets/cadeado_senha.png")),
              SizedBox(height: 20),
              Text("Nova Credencial", textAlign: TextAlign.center, style: TextStyle(fontSize: 40)),
              SizedBox(height: 26),
              Text("Seu e-mail foi verificado com sucesso! \n Digite a sua nova senha.", textAlign: TextAlign.center, style: TextStyle(fontSize: 18)),
              SizedBox(height: 26),
              Form(
                key: _formKey,
                child: Center(
                    child: Column(
                      children: [
                        Container(width: 340, height: 81,
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
                          SizedBox(height: 10),
                          Container(width: 340, height: 90,
                            child: TextFormField(
                              obscureText: _isVisible2 ? false : true,
                              decoration:  InputDecoration(
                                labelText: "Confirme sua senha",
                                labelStyle: TextStyle(color: Color.fromARGB(255, 88, 88, 88)),
                                hintText: "Digite sua senha novamente",
                                prefixIcon: const Icon(Icons.lock, color: Color.fromARGB(255, 88, 88, 88),size: 19),
                                suffixIcon: IconButton(
                                  onPressed: () => updateStatus2(),
                                  icon: Icon(_isVisible2 ? Icons.visibility : Icons.visibility_off),
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
                              controller: senha2C,
                              keyboardType: TextInputType.visiblePassword,
                              validator: (String? value) {
                                if (value!.isEmpty) {
                                  return 'O campo confirme a sua senha é obrigatório!';
                                }
                                if(senhaC.text != senha2C.text){
                                  return 'As senhas não coincidem';
                                }
                                return null;
                              },
                            )
                          ),
                      ],
                    ),
                )
              ),
              SizedBox(height: 25),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.grey),
                  borderRadius: BorderRadius.all(Radius.circular(57)),
                  color: Color.fromARGB(255, 0, 140, 255),
                ),
                width: 340,
                height: 50,
                child: TextButton(child: Text('Alterar Senha',style: TextStyle(color: Colors.black, fontSize: 28)),
                  onPressed: () async {
                     if (!_formKey.currentState!.validate()) {
                        return;
                      } else {
                        _formKey.currentState!.save();
                          bool deuCerto = await trocarSenha();
                          if(deuCerto){
                            senhaC.clear();
                            senha2C.clear();
                            Navigator.pushReplacementNamed(context, '/screens/forgot_password/forgot_password_sucess_page');
                          }else{
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content:Text('Erro ao alterar senha!',textAlign:TextAlign.center),
                              backgroundColor:Colors.redAccent,
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