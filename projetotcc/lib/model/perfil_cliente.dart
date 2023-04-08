// ignore_for_file: file_names, non_constant_identifier_names
import 'package:projetotcc/model/url.dart';

class Cliente {
  final String IDUsuario;
  final String IDCliente;
  final String Foto;
  final String Fotodata;
  final String Nome;
  final String Email;
  final String Senha;
  final String Telefone;
  final String CPF;
  final String Estado;
  final String Cidade;
  final String Bairro;
  final String Endereco;
  final String CEP;

  Cliente({
    required this.IDUsuario,
    required this.IDCliente,
    required this.Foto,
    required this.Fotodata,
    required this.Nome,
    required this.Email,
    required this.Senha,
    required this.Telefone,
    required this.CPF,
    required this.Estado,
    required this.Cidade,
    required this.Bairro,
    required this.Endereco,
    required this.CEP,
   
  });

  factory Cliente.fromJson(Map<String, dynamic> jsonData) {
    return Cliente(
      IDUsuario: jsonData['IDUsuario'],
      IDCliente: jsonData['ID'],
      Foto: 'http://'+localhost+'/api_tcc/imageupload/${jsonData['Foto']}',
      Fotodata: jsonData['Foto'],
      Nome: jsonData['Nome'],
      Email: jsonData['Email'],
      Senha: jsonData['Senha'],
      Telefone: jsonData['Telefone'],
      CPF: jsonData['CPF'],
      Estado: jsonData['Estado'],
      Cidade: jsonData['Cidade'],
      Bairro: jsonData['Bairro'],
      Endereco: jsonData['Endereco'],
      CEP: jsonData['CEP'],
    );
  }
}
