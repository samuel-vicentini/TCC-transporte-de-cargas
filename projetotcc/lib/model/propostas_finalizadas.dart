// ignore_for_file: file_names, non_constant_identifier_names, prefer_interpolation_to_compose_strings

import 'package:projetotcc/model/url.dart';

class PropostasFinalizadas {
  final String TipoProduto;
  final String TipoCarga;
  final String TipoVeiculo;
  final String Descricao;
  final String DataRetirada;
  final String DataEntrega;
  final String Origem;
  final String Destino;
  final String Massa;
  final String Unidade;
  final String Quantidade;
  final String possuiSeguro;
  final String PrecisaSerRefrigerado;
  final String Valor;
  final String DataAceita;
  final String DataFinal;
  final String Foto;
  final String Fotodata;
  final String Nome;
  final String Telefone;
  final String Email;

  PropostasFinalizadas({    
    required this.TipoProduto,
    required this.TipoCarga,
    required this.TipoVeiculo,
    required this.Descricao,
    required this.DataRetirada,
    required this.DataEntrega,
    required this.Origem,
    required this.Destino,
    required this.Massa,
    required this.Unidade,
    required this.Quantidade,
    required this.possuiSeguro,
    required this.PrecisaSerRefrigerado,
    required this.Valor,
    required this.DataAceita,
    required this.DataFinal,
    required this.Foto,
    required this.Fotodata,
    required this.Nome,
    required this.Telefone,
    required this.Email,
  });

  factory PropostasFinalizadas.fromJson(Map<String, dynamic> jsonData) {
    return PropostasFinalizadas(
      TipoProduto: jsonData['TipoProduto'],
      TipoCarga: jsonData['TipoCarga'],
      TipoVeiculo: jsonData['TipoVeiculo'],
      Descricao: jsonData['Descricao'],
      DataRetirada: jsonData['DataRetirada'],
      DataEntrega: jsonData['DataEntrega'],
      Origem: jsonData['Origem'],
      Destino: jsonData['Destino'],
      Massa: jsonData['Massa'],
      Unidade: jsonData['Unidade'],
      Quantidade: jsonData['Quantidade'],
      possuiSeguro: jsonData['TemSeguro'],
      PrecisaSerRefrigerado: jsonData['PrecisaSerRefrigerado'],
      Valor: jsonData['Valor'],
      DataAceita: jsonData['DataAceita'],
      DataFinal: jsonData['DataFinal'],
      Foto: 'http://'+localhost+'/api_tcc/imageupload/${jsonData['Foto']}',
      Fotodata: jsonData['Foto'],
      Nome: jsonData['Nome'],
      Telefone: jsonData['Telefone'],
      Email: jsonData['Email'],
    );
  }
}