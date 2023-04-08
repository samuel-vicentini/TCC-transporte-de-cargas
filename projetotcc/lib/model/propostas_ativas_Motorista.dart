//ignore_for_file: non_constant_identifier_names, prefer_interpolation_to_compose_strings
import 'package:projetotcc/model/url.dart';

class PropostaAtivaMotorista{
  final String IDProposta;
  final String IDCliente;
  final String IDMotorista; 
  final String IDFretamento;
  final String IDVeiculo;
  //Cliente
  final String FotoCliente;
  final String FotodataCliente;
  final String NomeCliente;
  final String TelefoneCliente;
  final String EmailCliente;
  //Veículo Usado
  final String FotoVeiculo;
  final String FotodataVeiculo;
  final String DescricaoVeiculo;
  final String PlacaVeiculo;
  // Proposta atual
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
  final String StatusFretamento;


  PropostaAtivaMotorista({
    required this.IDProposta,
    required this.IDCliente,
    required this.IDMotorista,
    required this.IDFretamento,
    required this.IDVeiculo,
    required this.FotoCliente,
    required this.FotodataCliente,
    required this.NomeCliente,
    required this.TelefoneCliente,
    required this.EmailCliente,
    required this.FotoVeiculo,
    required this.FotodataVeiculo,
    required this.DescricaoVeiculo,
    required this.PlacaVeiculo,
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
    required this.StatusFretamento

  });

  factory PropostaAtivaMotorista.fromJson(Map<String, dynamic> jsonData) {
    return PropostaAtivaMotorista(
      IDProposta: jsonData['IDProposta'],
      IDCliente: jsonData['IDCliente'],
      IDMotorista: jsonData['IDMotorista'],
      IDFretamento: jsonData['IDFretamento'],
      IDVeiculo: jsonData['IDVeiculo'],
      FotoCliente: 'http://'+localhost+'/api_tcc/imageupload/${jsonData['FotoCliente']}',
      FotodataCliente: jsonData['FotoCliente'],
      NomeCliente: jsonData['Nome'],
      TelefoneCliente: jsonData['Telefone'],
      EmailCliente: jsonData['Email'],
      FotoVeiculo: 'http://'+localhost+'/api_tcc/imageupload_veiculo/${jsonData['FotoVeiculo']}',
      FotodataVeiculo: jsonData['FotoVeiculo'],
      DescricaoVeiculo: jsonData['DescricaoVeiculo'],
      PlacaVeiculo: jsonData['PlacaVeiculo'],
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
      TemSeguro: jsonData['TemSeguro'],
      PrecisaSerRefrigerado: jsonData['PrecisaSerRefrigerado'],
      Valor: jsonData['Valor'],
      StatusFretamento: jsonData['StatusFretamento'],
    );
  }
}