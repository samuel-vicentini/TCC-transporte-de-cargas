// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';

String? groupValue = "";
final nomeC = TextEditingController();
final emailC = TextEditingController();
final senhaC = TextEditingController();
final telefoneC = TextEditingController();
final cpfC = TextEditingController();
final estadoC = TextEditingController();
final cidadeC = TextEditingController();
final bairroC = TextEditingController();
final enderecoC = TextEditingController();
final cepC = TextEditingController();

Widget buildNome() {
  return TextFormField(
    decoration: const InputDecoration(
      labelText: 'Nome',
      labelStyle: TextStyle(color: Color.fromARGB(255, 88, 88, 88)),
      hintText: 'Digite seu nome',
      prefixIcon: Icon(Icons.person, color: Color.fromARGB(255, 88, 88, 88),size: 19),
      border: OutlineInputBorder(
         borderRadius: BorderRadius.all(Radius.circular(22)),
         borderSide: BorderSide(color: Color.fromARGB(255, 88, 88, 88)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(22)),
        borderSide: BorderSide(color: Color.fromARGB(255, 88, 88, 88)),
      ),
    ),
    keyboardType: TextInputType.text,
    controller: nomeC,
    validator: (String? value) {
      if (value!.isEmpty) {
        return 'O campo nome é obrigatório!';
      }
      return null;
    },
  );
}

Widget buildEmail() {
  return TextFormField(
    decoration: const InputDecoration(
      labelText: 'E-mail',
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
    validator: (String? value) {
      if (value!.isEmpty) {
        return 'O campo e-mail é obrigatório!';
      }
      if (!RegExp(
              r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
          .hasMatch(value)) {
        return 'Por favor digite um e-mail válido';
      }
      return null;
    },
  );
}

Widget buildTelefone() {
  return TextFormField(
    decoration: const InputDecoration(
      counterText: "",
      labelText: 'Número de Telefone',
      labelStyle: TextStyle(color: Color.fromARGB(255, 88, 88, 88)),
      hintText: 'Digite seu número de telefone',
      prefixIcon: Icon(Icons.phone, color: Color.fromARGB(255, 88, 88, 88),size: 19),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(22)),
        borderSide: BorderSide(color: Color.fromARGB(255, 88, 88, 88)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(22)),
        borderSide: BorderSide(color: Color.fromARGB(255, 88, 88, 88)),
      ),
    ),
    maxLength: 15,
    controller: telefoneC,
    keyboardType: TextInputType.phone,
    validator: (String? value) {
      if (value!.isEmpty) {
        return 'O campo telefone é obrigatório!';
      }
      return null;
    },
  );
}

Widget buildCPF() {
  return TextFormField(
    decoration: const InputDecoration(
      labelText: 'CPF',
      labelStyle: TextStyle(color: Color.fromARGB(255, 88, 88, 88)),
      hintText: 'Digite seu CPF',
      prefixIcon: Icon(Icons.person_add_alt_sharp, color: Color.fromARGB(255, 88, 88, 88),size: 19),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(22)),
        borderSide: BorderSide(color: Color.fromARGB(255, 88, 88, 88)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(22)),
        borderSide: BorderSide(color: Color.fromARGB(255, 88, 88, 88)),
      ),
    ),
    controller: cpfC,
    keyboardType: TextInputType.number,
    validator: (String? value) {
      if (value!.isEmpty) {
        return 'O campo CPF é obrigatório!';
      }
      return null;
    },
  );
}

Widget buildEstado() {
  return TextFormField(
    decoration: const InputDecoration(
      counterText: "",
      labelText: 'Estado',
      labelStyle: TextStyle(color: Color.fromARGB(255, 88, 88, 88)),
      hintText: 'Digite o seu Estado',
      prefixIcon: Icon(Icons.location_pin, color: Color.fromARGB(255, 88, 88, 88),size: 19),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(22)),
        borderSide: BorderSide(color: Color.fromARGB(255, 88, 88, 88)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(22)),
        borderSide: BorderSide(color: Color.fromARGB(255, 88, 88, 88)),
      ),
    ),
    maxLength: 2,
    controller: estadoC,
    keyboardType: TextInputType.text,
    validator: (String? value) {
      if (value!.isEmpty) {
        return 'O campo Estado é obrigatório!';
      }
      return null;
    },
  );
}

Widget buildCidade() {
  return TextFormField(
    decoration: const InputDecoration(
      labelText: 'Cidade',
      labelStyle: TextStyle(color: Color.fromARGB(255, 88, 88, 88)),
      hintText: 'Digite o nome da sua Cidade',
      prefixIcon: Icon(Icons.location_city, color: Color.fromARGB(255, 88, 88, 88),size: 19),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(22)),
        borderSide: BorderSide(color: Color.fromARGB(255, 88, 88, 88)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(22)),
        borderSide: BorderSide(color: Color.fromARGB(255, 88, 88, 88)),
      ),
    ),
    controller: cidadeC,
    keyboardType: TextInputType.text,
    validator: (String? value) {
      if (value!.isEmpty) {
        return 'O campo Cidade é obrigatório!';
      }
      return null;
    },
  );
}

Widget buildBairro() {
  return TextFormField(
    decoration: const InputDecoration(
      labelText: 'Bairro',
      labelStyle: TextStyle(color: Color.fromARGB(255, 88, 88, 88)),
      hintText: 'Digite o nome do seu Bairro',
      prefixIcon: Icon(Icons.location_pin, color: Color.fromARGB(255, 88, 88, 88),size: 19),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(22)),
        borderSide: BorderSide(color: Color.fromARGB(255, 88, 88, 88)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(22)),
        borderSide: BorderSide(color: Color.fromARGB(255, 88, 88, 88)),
      ),
    ),
    controller: bairroC,
    keyboardType: TextInputType.text,
    validator: (String? value) {
      if (value!.isEmpty) {
        return 'O campo Bairro é obrigatório!';
      }
      return null;
    },
  );
}

Widget buildEndereco() {
  return TextFormField(
    decoration: const InputDecoration(
      labelText: 'Endereço',
      labelStyle: TextStyle(color: Color.fromARGB(255, 88, 88, 88)),
      hintText: 'Digite o seu Endereço',
      prefixIcon: Icon(Icons.location_pin, color: Color.fromARGB(255, 88, 88, 88),size: 19),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(22)),
        borderSide: BorderSide(color: Color.fromARGB(255, 88, 88, 88)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(22)),
        borderSide: BorderSide(color: Color.fromARGB(255, 88, 88, 88)),
      ),
    ),
    controller: enderecoC,
    keyboardType: TextInputType.text,
    validator: (String? value) {
      if (value!.isEmpty) {
        return 'O campo Endereço é obrigatório!';
      }
      return null;
    },
  );
}

Widget buildCEP() {
  return TextFormField(
    decoration: InputDecoration(
      counterText: "",
      labelText: 'CEP',
      labelStyle: TextStyle(color: Color.fromARGB(255, 88, 88, 88)),
      hintText: 'Digite seu CEP',
      prefixIcon: Icon(Icons.location_pin, color: Color.fromARGB(255, 88, 88, 88),size: 19),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(22)),
        borderSide: BorderSide(color: Color.fromARGB(255, 88, 88, 88)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(22)),
        borderSide: BorderSide(color: Color.fromARGB(255, 88, 88, 88)),
      ),
    ),
    maxLength: 8,
    controller: cepC,
    keyboardType: TextInputType.number,
    validator: (String? value) {
      if(value!.isEmpty){
        return "O campo CEP é obrigatório";
      }
      return null;
    },
  );
}