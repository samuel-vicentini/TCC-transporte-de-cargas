// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({ Key? key }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:<Widget>[
            Image.asset('assets/caminhao.jpg', width: 200, height: 200),
            Text("Transporte de Cargas",style: TextStyle(fontSize: 30))
          ]))
    );
  }
}