// ignore_for_file: non_constant_identifier_names, file_names
import 'package:projetotcc/model/url.dart';

class Veiculo {
  final String ID;
  final String IDMotorista;
  final String Foto;
  final String Fotodata;
  final String Descricao;
  final String Placa; 
  final String Modelo;
  final String Ano;
  final String PossuiSeguro;
  final String PossuiRefrigeracao;


  Veiculo({
    required this.ID,
    required this.IDMotorista,
    required this.Foto,
    required this.Fotodata,
    required this.Descricao,
    required this.Placa,
    required this.Modelo,
    required this.Ano,
    required this.PossuiSeguro,  
    required this.PossuiRefrigeracao,
   
  });

  factory Veiculo.fromJson(Map<String, dynamic> jsonData) {
    return Veiculo(
      ID: jsonData['ID'],
      IDMotorista: jsonData['IDMotorista'],
      Foto: 'http://'+localhost+'/api_tcc/imageupload_veiculo/${jsonData['Foto']}',
      Fotodata: jsonData['Foto'],
      Descricao: jsonData['Descricao'],
      Placa: jsonData['Placa'],
      Modelo: jsonData['Modelo'],
      Ano: jsonData['Ano'],
      PossuiSeguro: jsonData['PossuiSeguro'],
      PossuiRefrigeracao: jsonData['PossuiRefrigeracao'],
    );
  }
}
