// ignore_for_file: prefer_const_constructors, file_names
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

String? idUsuario;
String? perfil;
String? token;
int? caracteres;

class TokenPage extends StatefulWidget {
  const TokenPage({ Key? key }) : super(key: key);

  @override
  State<TokenPage> createState() => _TokenPageState();
}

class _TokenPageState extends State<TokenPage> {
 
  @override
  void initState() {
    super.initState();
    verficarToken().then((value) {
      if(value){
        caracteres =  token!.length;
        idUsuario = token?.substring(33, caracteres); 
        perfil = token?.substring(32, 33); 
        if(perfil == "M"){
          Navigator.pushReplacementNamed(context, '/screens/homeMotorista/home_motorista_page');        
        }else{
          Navigator.pushReplacementNamed(context, '/screens/homeCliente/home_cliente_page');
        }
      }else{
        Navigator.pushReplacementNamed(context, '/screens/login/login_page');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }

  Future<bool> verficarToken() async{
    SharedPreferences sharedPreference = await SharedPreferences.getInstance();
    if(sharedPreference.getString('token') == null){
      return false;  
    }else{
      token = sharedPreference.getString('token');
      return true;
    }
  }
}