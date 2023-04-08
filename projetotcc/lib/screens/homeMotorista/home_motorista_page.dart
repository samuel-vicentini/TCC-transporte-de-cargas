// ignore_for_file: prefer_const_constructors
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:projetotcc/screens/homeMotorista/aceitar_propostas_page.dart';
import 'package:projetotcc/screens/homeMotorista/propostas_ativas_page.dart';
import 'package:projetotcc/screens/homeMotorista/perfil_page.dart';

int indexglobal = 0;

class HomeMotoristaPage extends StatefulWidget {
  const HomeMotoristaPage({ Key? key }) : super(key: key);

  @override
  State<HomeMotoristaPage> createState() => _HomeMotoristaPageState();
}

class _HomeMotoristaPageState extends State<HomeMotoristaPage> {

  int index = indexglobal;
  final screens = [
    PropostasAtivasPage(),
    AceitarPropostaPage(),
    PerfilMotorista()
  ];
  
  @override
  Widget build(BuildContext context) {

    final items = <Widget>[
      Icon(Icons.directions_car, size: 33),
      Icon(Icons.search, size: 33),
      Icon(Icons.person, size: 33),
    ];

   return Scaffold(
      body: screens[index],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.white,
        height: 60,
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 350),
        items: items,
        index: index,
        onTap: (index) => setState(() => this.index = index),
      ));
  }
}