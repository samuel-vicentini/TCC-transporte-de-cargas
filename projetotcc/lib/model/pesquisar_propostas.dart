// ignore_for_file: file_names, non_constant_identifier_names
class PesquisarPropostas {
  final String ID;
  final String IDCliente;
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

  PesquisarPropostas({    
    required this.ID,
    required this.IDCliente,
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
  });

  factory PesquisarPropostas.fromJson(Map<String, dynamic> jsonData) {
    return PesquisarPropostas(
      ID: jsonData['ID'],
      IDCliente: jsonData['IDCliente'],
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
    );
  }
}