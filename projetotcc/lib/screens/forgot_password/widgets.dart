import 'package:flutter/material.dart';

final emailC = TextEditingController();
final senhaC = TextEditingController();
final senha2C = TextEditingController();
String? emailtrocarsenha;
String? otp;
String? email;

Widget buildEmail() {
  return TextFormField(
    decoration: const InputDecoration(
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
        return 'O campo é obrigatório!';
      }
      if (!RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
          .hasMatch(value)) {
        return 'Por favor digite um e-mail válido';
      }
      return null;
    },
  );
}
