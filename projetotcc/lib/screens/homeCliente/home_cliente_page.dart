// ignore_for_file: prefer_const_constructors
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:projetotcc/screens/homeCliente/criar_proposta_page.dart';
import 'package:projetotcc/screens/homeCliente/perfil_page.dart';
import 'package:projetotcc/screens/homeCliente/propostas_ativas_page.dart';
import 'package:projetotcc/screens/homeCliente/propostas_criadas_page.dart';

int indexglobal = 0;

class HomeClientePage extends StatefulWidget {
  const HomeClientePage({ Key? key }) : super(key: key);

  @override
  State<HomeClientePage> createState() => _HomeClientePageState();
}

class _HomeClientePageState extends State<HomeClientePage> {

  int index = indexglobal;    
  final screens = [
    PropostasAtivasPage(),
    PropostasCriadasPage(),
    CriarPropostaPage(),
    PerfilCliente()
  ];
  
  @override
  Widget build(BuildContext context) {
        
    final items = [
      Icon(Icons.directions_car, size: 33),
      Icon(Icons.search, size: 33),
      Icon(Icons.add_box, size: 33),
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
        onTap: (index) => setState(() => { this.index = index}),
      ));
  }
}