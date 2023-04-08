// ignore_for_file: non_constant_identifier_names, prefer_interpolation_to_compose_strings
import 'package:projetotcc/model/url.dart';

class PropostaAtivaCliente{
  final String IDProposta;
  final String IDCliente;
  final String IDMotorista; 
  final String IDFretamento;
  final String FotoMotorista;
  final String FotodataMotorista;
  final String NomeMotorista;
  final String TelefoneMotorista;
  final String EmailMotorista;
  final String FotoVeiculo;
  final String FotodataVeiculo;
  final String DescricaoVeiculo;
  final String PlacaVeiculo;
  final String PossuiSeguroV;
  final String StatusFretamento;
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
  final String TemSeguro;
  final String PrecisaSerRefrigerado;
  final String Valor;

  PropostaAtivaCliente({
    required this.IDProposta,
    required this.IDCliente,
    required this.IDMotorista,
    required this.IDFretamento,
    required this.FotoMotorista,
    required this.FotodataMotorista,
    required this.NomeMotorista,
    required this.TelefoneMotorista,
    required this.EmailMotorista,
    required this.FotoVeiculo,
    required this.FotodataVeiculo,
    required this.DescricaoVeiculo,
    required this.PlacaVeiculo,
    required this.PossuiSeguroV,
    required this.StatusFretamento,
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
    required this.TemSeguro,
    required this.PrecisaSerRefrigerado,
    required this.Valor,
  });

  factory PropostaAtivaCliente.fromJson(Map<String, dynamic> jsonData) {
    return PropostaAtivaCliente(
      IDProposta: jsonData['IDProposta'],
      IDCliente: jsonData['IDCliente'],
      IDMotorista: jsonData['IDMotorista'],
      IDFretamento: jsonData['IDFretamento'],
      FotoMotorista: 'http://'+localhost+'/api_tcc/imageupload/${jsonData['FotoMotorista']}',
      FotodataMotorista: jsonData['FotoMotorista'],
      NomeMotorista: jsonData['Nome'],
      TelefoneMotorista: jsonData['Telefone'],
      EmailMotorista: jsonData['Email'],
      FotoVeiculo: 'http://'+localhost+'/api_tcc/imageupload_veiculo/${jsonData['FotoVeiculo']}',
      FotodataVeiculo: jsonData['FotoVeiculo'],
      DescricaoVeiculo: jsonData['DescricaoVeiculo'],
      PlacaVeiculo: jsonData['Placa'],
      PossuiSeguroV: jsonData['PossuiSeguro'],
      TipoProduto: jsonData['TipoProduto'],
      TipoCarga: jsonData['TipoCarga'],
      TipoVeiculo: jsonData['TipoVeiculo'],
      Descricao: jsonData['DescricaoProposta'],
      DataRetirada: jsonData['DataRetirada'],
      DataEntrega: jsonData['DataEntrega'],
      Origem: jsonData['Origem'],
      Destino: jsonData['Destino'],
      Massa: jsonData['Massa'],
      Unidade: jsonData['Unidade'],
      Quantidade: jsonData['Quantidade'],
      TemSeguro: jsonData['TemSeguro'],
      PrecisaSerRefrigerado: jsonData['PrecisaSerRefrigerado'],
      Valor: jsonData['Valor'],
      StatusFretamento: jsonData['Status'],
    );
  }
}