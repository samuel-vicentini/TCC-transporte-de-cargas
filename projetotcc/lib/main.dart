// ignore_for_file: prefer_const_constructors
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:projetotcc/screens/forgot_password/forgot_password_change_page.dart';
import 'package:projetotcc/screens/forgot_password/forgot_password_otp_page.dart';
import 'package:projetotcc/screens/forgot_password/forgot_password_page.dart';
import 'package:projetotcc/screens/forgot_password/forgot_password_sucess_page.dart';
import 'package:projetotcc/screens/homeCliente/home_cliente_page.dart';
import 'package:projetotcc/screens/homeCliente/propostas_criadas_page.dart';
import 'package:projetotcc/screens/homeMotorista/filtrar_propostas_page.dart';
import 'package:projetotcc/screens/homeMotorista/home_motorista_page.dart';
import 'package:projetotcc/screens/homeMotorista/perfil_page.dart';
import 'package:projetotcc/screens/login/login_page.dart';
import 'package:projetotcc/screens/homeMotorista/cadastro_veiculos_page.dart';
import 'package:projetotcc/screens/register/register_page.dart';
import 'package:projetotcc/screens/register/success_page.dart';
import 'package:projetotcc/screens/splash/splash_page.dart';
import 'package:projetotcc/services/VerificarToken.dart';

void main() {
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/screens/login/login_page': (_) => LoginPage(),
        '/screens/register/register_page': (_) => RegisterPage(),
        '/screens/homeMotorista/cadastro_veiculos_page': (_) => CadastroVeiculoPage(),
        '/screens/register/success_page': (_) => RegisterSuccessPage(),
        '/screens/forgot_password/forgot_password_page': (_) => ForgotPasswordPage(),
        '/screens/forgot_password/forgot_password_otp_page': (_) => ForgotPasswordOTPPage(),
        '/screens/forgot_password/forgot_password_change_page': (_) => ForgotPasswordChangePage(),
        '/screens/forgot_password/forgot_password_sucess_page': (_) => ForgotPasswordSucessPage(),
        '/screens/homeCliente/home_cliente_page': (_) => HomeClientePage(),
        '/screens/homeCliente/propostas_criadas_page': (_) => PropostasCriadasPage(),
        '/screens/homeMotorista/home_motorista_page': (_) => HomeMotoristaPage(),
        '/screens/homeMotorista/filtrar_propostas_page': (_) => FiltrarPropostaPage(),
        '/screens/homeMotorista/perfil_page':(_) => VeiculosPage(), 
      },
      home: AnimatedSplashScreen.withScreenFunction(
        duration: 1000,
        splashIconSize: 1000,
        splash: SplashPage(),
        splashTransition: SplashTransition.fadeTransition,
        screenFunction: () async {
          return TokenPage();
        },
      )));
}