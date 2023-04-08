// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, prefer_interpolation_to_compose_strings
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:projetotcc/model/pesquisar_propostas.dart';
import 'package:http/http.dart' as http;
import 'package:projetotcc/model/url.dart';
import 'package:projetotcc/screens/homeMotorista/filtrar_propostas_page.dart';
import 'package:projetotcc/screens/homeMotorista/home_motorista_page.dart';
import 'package:projetotcc/services/VerificarToken.dart';
import 'widgets.dart';

Future<List<PesquisarPropostas>> downloadJSONPropostas() async {
  var url = Uri.parse('http://'+localhost+'/api_tcc/AceitarProposta/propostasfeitas.php');
  var resposta = await http.post(
      url,
      body: {
        'TipoProduto': dropValueProduto.value.toString(),
        'TipoCarga': dropValueCarga.value.toString(),
        'TipoVeiculo': dropValueVeiculo.value.toString(),
        'DataRetirada': dataR.toString(),
        'DataEntrega': dataE.toString(),
        'Origem': origemC.text.toString(),
        'Destino': destinoC.text.toString(),
        'Massa': massaC.text.toString(),
        'Unidade': dropValueUnidade.value.toString(),
        'Quantidade': quantidadeC.text.toString(),
        'TemSeguro': possuiSeguroS.toString(),
        'PrecisaSerRefrigerado': precisaRefrigeracaoS.toString(),
        'ValorMin': valorC.text.toString()
      },
  );
  if (resposta.statusCode == 200) {
    List propostasfeitas = json.decode(resposta.body);
    return propostasfeitas.map((propostasfeitas) => PesquisarPropostas.fromJson(propostasfeitas)).toList();
  } else {
    throw Exception('Erro ao recuperar dados!!!');
  }
}

class CustomListView extends StatefulWidget {
  final List<PesquisarPropostas> propostasfeitas;
  CustomListView(this.propostasfeitas);

  @override
  State<CustomListView> createState() => _CustomListViewState();
}
class _CustomListViewState extends State<CustomListView> {

  String? idCliente = "";
  String? idProposta = "";
  Future aceitarProposta() async{
    var url=Uri.parse('http://'+localhost+'/api_tcc/AceitarProposta/aceitarproposta.php');
    var resposta= await http.post(url,
        body: {
          'IDUsuario': idUsuario.toString(),
          'IDCliente':  idCliente.toString(),
          'IDProposta':  idProposta.toString(),
        },
    );
    if(resposta.statusCode == 200 && json.decode(resposta.body.toString()) == "Success"){
      indexglobal = 0;
      Navigator.pushReplacementNamed(context, '/screens/homeMotorista/home_motorista_page');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Proposta Aceita com Sucesso!',textAlign:TextAlign.center, style: TextStyle(fontSize: 22, color: Colors.white)),
        backgroundColor:Colors.greenAccent,duration: Duration(milliseconds: 2300),
      ));     
    }else if(resposta.statusCode == 200 && json.decode(resposta.body.toString()) == "Ja tem proposta ativa"){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Você já possui uma Proposta Ativa!',textAlign:TextAlign.center, style: TextStyle(fontSize: 22, color: Colors.white)),
        backgroundColor:Color.fromARGB(255, 245, 82, 82),duration: Duration(milliseconds: 2500),
      )); 
      indexglobal = 1;
      Navigator.pop(context, '/screens/homeMotorista/home_motorista_page');
    }else{
      print('erro');
    }
  }


  Widget build(context) {
    return RefreshIndicator(
      onRefresh: () async{ 
        indexglobal = 1;
        Navigator.pushReplacementNamed(context, '/screens/homeMotorista/home_motorista_page');
      },
      child: ListView.builder(
        itemCount: widget.propostasfeitas.length,
        itemBuilder: (context, int currentIndex) {
          return createViewItem(widget.propostasfeitas[currentIndex], context);
        },
      ),
    );
  }

  Widget createViewItem(PesquisarPropostas propostasfeitas, BuildContext context) {
    return Card(
      color: Colors.white,
      child: Container(
        height: 655,
        decoration: BoxDecoration(border: Border.all(color: Colors.black54)),
        padding: EdgeInsets.all(3),
        margin: EdgeInsets.all(5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Center(child: Text("Descrição:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
            SizedBox(height: 6),
            Text(propostasfeitas.Descricao, style: TextStyle(fontSize: 17)),
            Divider(color: Colors.black, thickness: 1),
            Center(child: Text("Detalhes da Proposta:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
            SizedBox(height: 9),
            Row(children: [
              Text("Valor: ", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(width: 6),
              Text('R\$ ${propostasfeitas.Valor}', style: TextStyle(fontSize: 18)),
            ]),
            SizedBox(height: 9),
            Row(children: [
              Text("Tipo do Produto:", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
              SizedBox(width: 6),
              Text(propostasfeitas.TipoProduto, style: TextStyle(fontSize: 16.5)),
            ]),
            SizedBox(height: 9),
            Row(children: [
              Text("Tipo da Carga:", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
              SizedBox(width: 6),
              Text(propostasfeitas.TipoCarga, style: TextStyle(fontSize: 16.5)),
            ]),
            SizedBox(height: 9),
            Row(children: [
              Text("Tipo do Veículo:", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
              SizedBox(width: 6),
              Text(propostasfeitas.TipoVeiculo, style: TextStyle(fontSize: 16.5)),
            ]),
            SizedBox(height: 9),
            Row(children: [
              Text("Quantidade:", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
              SizedBox(width: 6),
              Text(propostasfeitas.Quantidade, style: TextStyle(fontSize: 17)),
            ]),
            SizedBox(height: 9),
            Row(children: [
              Text("Massa:", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
              SizedBox(width: 6),
              Text(propostasfeitas.Massa, style: TextStyle(fontSize: 17)),
              SizedBox(width: 2),
              Text(propostasfeitas.Unidade, style: TextStyle(fontSize: 17)),
            ]),
            Divider(color: Colors.black, thickness: 1),
            Row(children: [
              Text("Data de Retirada:", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
              SizedBox(width: 6),
              Text(propostasfeitas.DataRetirada, style: TextStyle(fontSize: 17)),
            ]),
            SizedBox(height: 9),
            Row(children: [
              Text("Data de Entrega:", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
              SizedBox(width: 6),
              Text(propostasfeitas.DataEntrega, style: TextStyle(fontSize: 17)),
            ]),
            SizedBox(height: 9),
            Text("Origem:", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            SizedBox(height: 6),
            Text(propostasfeitas.Origem, style: TextStyle(fontSize: 17)),
            SizedBox(height: 9),
            Text("Destino:", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            SizedBox(height: 6),
            Text(propostasfeitas.Destino, style: TextStyle(fontSize: 17)),
            SizedBox(height: 9),
            Row(children: [
              Text("Possui Seguro:", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
              SizedBox(width: 6),
              Text(propostasfeitas.possuiSeguro == "true" ? "Sim" : "Não", style: TextStyle(fontSize: 17)),
            ]),
            SizedBox(height: 9),
            Row(children: [
              Text("Precisa de Refrigeração:", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
              SizedBox(width: 6),
              Text(propostasfeitas.PrecisaSerRefrigerado == "true" ? "Sim" : "Não", style: TextStyle(fontSize: 17)),
            ]),
            Divider(color: Colors.black, thickness: 1),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(350, 50),
                    primary: Colors.lightBlue,
                    textStyle: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold)
                  ),
                  child: Text("Aceitar Proposta",style: TextStyle(fontSize: 20)),
                  onPressed: () async {
                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: Text('Aceitar Proposta'),
                        content: Text('Você tem certeza que deseja aceitar essa proposta?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'Cancel'),
                            child: Text('Cancelar'),
                          ),
                          TextButton(
                            onPressed: () async {
                              idProposta = propostasfeitas.ID;
                              idCliente = propostasfeitas.IDCliente;
                              await aceitarProposta();
                            },
                            child: Text('Sim'),
                          ),
                        ],
                      ),
                    );
                  }
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class AceitarPropostaPage extends StatefulWidget {
  const AceitarPropostaPage({Key? key}) : super(key: key);

  @override
  State<AceitarPropostaPage> createState() => _AceitarPropostaPageState();
}

class _AceitarPropostaPageState extends State<AceitarPropostaPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text("Procurar Propostas"), centerTitle: true, automaticallyImplyLeading: false,actions: [
          IconButton(icon: Icon(Icons.filter_list), onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => FiltrarPropostaPage()));
            dropValueProduto.value = dropValueProduto.value;
            dropValueCarga.value = dropValueCarga.value;
            dropValueVeiculo.value = dropValueVeiculo.value;
            origemC.text = origemC.text;
            destinoC.text = destinoC.text;
            quantidadeC.text = quantidadeC.text;
            massaC.text = massaC.text;
            dropValueUnidade.value = dropValueUnidade.value;
            valorC.text = valorC.text;
            dataR = dataR;
            dataE = dataE;
            possuiSeguroS = possuiSeguroS;
            precisaRefrigeracaoS = precisaRefrigeracaoS;  
            possuiumSeguro = possuiumSeguro;
            precisadeRefrigeracao = precisadeRefrigeracao;
          }), 
        ]),
        body: Center(
          child: FutureBuilder<List<PesquisarPropostas>>(
            future:  downloadJSONPropostas(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<PesquisarPropostas> propostasfeitas = snapshot.requireData.toList();
                if(propostasfeitas.toString() == "[]"){
                  return Text("Não existe nenhuma proposta!", style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold));
                }
                return CustomListView(propostasfeitas);
              } else if (snapshot.hasError) {
                print(snapshot.error.toString());
                return Text('${snapshot.error}');
              }
              return CircularProgressIndicator();
            }, 
          ),
        ),
      ),
    );  
  }
}