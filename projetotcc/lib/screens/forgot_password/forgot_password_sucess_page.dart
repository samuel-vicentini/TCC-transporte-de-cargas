// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace
import 'package:flutter/material.dart';

class ForgotPasswordSucessPage extends StatefulWidget {
  const ForgotPasswordSucessPage({ Key? key }) : super(key: key);

  @override
  _ForgotPasswordSucessPageState createState() => _ForgotPasswordSucessPageState();
}

class _ForgotPasswordSucessPageState extends State<ForgotPasswordSucessPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Senha Alterada", textAlign: TextAlign.center, style: TextStyle(fontSize: 40)),
              SizedBox(height: 50),
              Container(width: 150, height: 150, child: Image.asset("assets/success.png")),
              SizedBox(height: 50),
              Text("Sucesso ao alterar a sua senha!", textAlign: TextAlign.center, style: TextStyle(fontSize: 18)),
              SizedBox(height: 55),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.grey),
                  borderRadius: BorderRadius.all(Radius.circular(57)),
                  color: Color.fromARGB(255, 0, 140, 255),
                ),
                width: 340,
                height: 50,
                child: TextButton(child: Text('Login',style: TextStyle(color: Colors.black, fontSize: 28)),
                onPressed: (){
                  Navigator.pushReplacementNamed(context, '/screens/login/login_page');
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