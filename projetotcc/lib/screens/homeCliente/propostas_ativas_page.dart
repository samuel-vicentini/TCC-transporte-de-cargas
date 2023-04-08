// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:projetotcc/model/propostas_ativas_Cliente.dart';
import 'package:projetotcc/model/url.dart';
import 'package:projetotcc/screens/homeCliente/home_cliente_page.dart';
import 'package:http/http.dart' as http;
import 'package:projetotcc/services/VerificarToken.dart';

Future<List<PropostaAtivaCliente>> downloadJSONPropostasAtivasC() async {
  var url = Uri.parse('http://'+localhost+'/api_tcc/AceitarProposta/propostasativasC.php');
  var resposta = await http.post(
      url,
      body: {
        'IDUsuario': idUsuario.toString(),
      },
  );
  if (resposta.statusCode == 200) {
    List propostasAtivasC = json.decode(resposta.body);
    return propostasAtivasC.map((propostasAtivasC) => PropostaAtivaCliente.fromJson(propostasAtivasC)).toList();
  } else {
    throw Exception('Erro ao recuperar dados!!!');
  }
}

String? IDFretamento;
String? IDProposta;
Future<bool> propostaEntregue() async {
  var url = Uri.parse('http://'+localhost+'/api_tcc/AceitarProposta/propostaEntregue.php');
  var resposta = await http.post(url, 
  headers: {'Charset': 'utf-8'},
  body:   
  {
    'IDFretamento': IDFretamento,
    'IDProposta': IDProposta,
  });
  if (resposta.statusCode == 200 && json.decode(resposta.body) == "Success") {
    return true;
  } else{
    return false;
  }
}



class CustomListView extends StatefulWidget {
  final List<PropostaAtivaCliente> propostasAtivasC;
  CustomListView(this.propostasAtivasC);

  @override
  State<CustomListView> createState() => _CustomListViewState();
}
class _CustomListViewState extends State<CustomListView> {
  Widget build(context) {
    return RefreshIndicator(
      onRefresh: () async{ 
        indexglobal = 0;
        Navigator.pushReplacementNamed(context, '/screens/homeCliente/home_cliente_page');
      },
      child: ListView.builder(
        itemCount: widget.propostasAtivasC.length,
        itemBuilder: (context, int currentIndex) {
          return createViewItem(widget.propostasAtivasC[currentIndex], context);
        },
      ),
    );
  }

  imagemMotorista(propostasAtivasC){
    return propostasAtivasC.FotodataMotorista.toString() == "../imageupload/Fotonãoexistente"
      ? ClipOval(child: Image.asset("assets/person_add.png",fit: BoxFit.fill,width: 120,height: 120))
      :ClipOval(
        child: Image.network(
        propostasAtivasC.FotoMotorista,
        width: 160,
        height: 160,
        fit: BoxFit.fill,
        ),
      );
  }
  imagemVeiculo(propostasAtivasC){
    return propostasAtivasC.FotodataVeiculo.toString() == "../imageupload_veiculo/Fotonãoexistente"
      ? ClipOval(child: Image.asset("assets/caminhao.jpg",fit: BoxFit.fill,width: 120,height: 120))
      :ClipOval(
        child: Image.network(
        propostasAtivasC.FotoVeiculo,
        width: 160,
        height: 160,
        fit: BoxFit.fill,
        ),
      );
  }

  double? alturaCard;


  Widget createViewItem(PropostaAtivaCliente propostasAtivasC, BuildContext context) {
    propostasAtivasC.StatusFretamento.toString() == "E" ?
    alturaCard = 1338
    :alturaCard = 1020;
    return InkWell(
      onTap: () {
        
      },
      child: Card(
        color: Colors.white,
        child: Container(
          height: alturaCard,
          decoration: BoxDecoration(border: Border.all(color: Colors.black54)),
          padding: EdgeInsets.all(5),
          margin: EdgeInsets.all(5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Center(child: Text("Descrição:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
              SizedBox(height: 6),
              Text(propostasAtivasC.Descricao, style: TextStyle(fontSize: 17)),
              SizedBox(height: 6),
              Center(child: Text("Detalhes da Proposta:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
              SizedBox(height: 9),
              Row(children: [
                Text("Valor a ser pago: ", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(width: 6),
                Text('R\$ ${propostasAtivasC.Valor}', style: TextStyle(fontSize: 18)),
              ]),
              SizedBox(height: 9),
              Row(children: [
                Text("Tipo do Produto:", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                SizedBox(width: 6),
                Text(propostasAtivasC.TipoProduto, style: TextStyle(fontSize: 16.5)),
              ]),
              SizedBox(height: 9),
              Row(children: [
                Text("Tipo da Carga:", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                SizedBox(width: 6),
                Text(propostasAtivasC.TipoCarga, style: TextStyle(fontSize: 16.5)),
              ]),
              SizedBox(height: 9),
              Row(children: [
                Text("Tipo do Veículo:", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                SizedBox(width: 6),
                Text(propostasAtivasC.TipoVeiculo, style: TextStyle(fontSize: 16.5)),
              ]),
              SizedBox(height: 9),
              Row(children: [
                Text("Quantidade:", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                SizedBox(width: 6),
                Text(propostasAtivasC.Quantidade, style: TextStyle(fontSize: 17)),
              ]),
              SizedBox(height: 9),
              Row(children: [
                Text("Massa:", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                SizedBox(width: 6),
                Text(propostasAtivasC.Massa, style: TextStyle(fontSize: 17)),
                SizedBox(width: 2),
                Text(propostasAtivasC.Unidade, style: TextStyle(fontSize: 17)),
              ]),
              SizedBox(height: 9),
              Row(children: [
                Text("Data de Retirada:", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                SizedBox(width: 6),
                Text(propostasAtivasC.DataRetirada, style: TextStyle(fontSize: 17)),
              ]),
              SizedBox(height: 9),
              Row(children: [
                Text("Data de Entrega:", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                SizedBox(width: 6),
                Text(propostasAtivasC.DataEntrega, style: TextStyle(fontSize: 17)),
              ]),
              SizedBox(height: 9),
              Text("Origem:", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
              SizedBox(height: 6),
              Text(propostasAtivasC.Origem, style: TextStyle(fontSize: 17)),
              SizedBox(height: 9),
              Text("Destino:", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
              SizedBox(height: 6),
              Text(propostasAtivasC.Destino, style: TextStyle(fontSize: 17)),
              SizedBox(height: 9),
              Row(children: [
                Text("Possui Seguro:", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                SizedBox(width: 6),
                Text(propostasAtivasC.TemSeguro == "true" ? "Sim" : "Não", style: TextStyle(fontSize: 17)),
              ]),
              SizedBox(height: 9),
              Row(children: [
                Text("Precisa de Refrigeração:", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                SizedBox(width: 6),
                Text(propostasAtivasC.PrecisaSerRefrigerado == "true" ? "Sim" : "Não", style: TextStyle(fontSize: 17)),
              ]),  
              SizedBox(height: 8),
              Divider(color: Colors.black, thickness: 1),
              SizedBox(height: 7),
              Center(child: Text("Motorista:", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold))),
              SizedBox(height: 20),
              Center(child: imagemMotorista(propostasAtivasC)),
              SizedBox(height: 15),
              Row(children: [
                Text("Nome: ", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                SizedBox(width: 6),
                Text(propostasAtivasC.NomeMotorista, style: TextStyle(fontSize: 17)),
              ]),
              SizedBox(height: 9),
              Row(children: [
                Text("Telefone: ", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                SizedBox(width: 6),
                Text(propostasAtivasC.TelefoneMotorista, style: TextStyle(fontSize: 17)),
              ]),
              SizedBox(height: 9),
              Row(children: [
                Text("E-mail: ", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(width: 6),
                Text(propostasAtivasC.EmailMotorista, style: TextStyle(fontSize: 17)),
              ]),
              SizedBox(height: 2),
              Divider(color: Colors.black, thickness: 1),
              SizedBox(height: 10),
              propostasAtivasC.StatusFretamento.toString() == "E" ?   
              Column(
                children: [
                  Center(child: Text("Veículo do Motorista:", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold))),
                  SizedBox(height: 20),
                  Center(child: imagemVeiculo(propostasAtivasC)),
                  SizedBox(height: 15),
                  Align(alignment: Alignment.centerLeft,child: Text("Descrição: ", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold))),
                  SizedBox(width: 6),
                  Text(propostasAtivasC.DescricaoVeiculo, style: TextStyle(fontSize: 17)),
                  SizedBox(height: 9),
                  Row(children: [
                    Text("Placa: ", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                    SizedBox(width: 6),
                    Text(propostasAtivasC.PlacaVeiculo, style: TextStyle(fontSize: 17)),
                  ]),
                  SizedBox(height: 9),
                  Row(children: [
                    Text("Possui Seguro:", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                  SizedBox(width: 6),
                  Text(propostasAtivasC.PossuiSeguroV == "true" ? "Sim" : "Não", style: TextStyle(fontSize: 17)),
                  ]),
                  SizedBox(height: 2),
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
                          child: Text("Proposta Recebida",style: TextStyle(fontSize: 20)),
                          onPressed: () async {
                            showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: Text('Proposta Recebida'),
                                content: Text('A Proposta foi Recebida e Paga com Sucesso?'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, 'Cancel'),
                                    child: Text('Cancelar'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      IDFretamento = propostasAtivasC.IDFretamento.toString();
                                      IDProposta = propostasAtivasC.IDProposta.toString();    
                                      bool deuCerto = await propostaEntregue();
                                      if(deuCerto){
                                        indexglobal = 0;
                                        Navigator.pushNamedAndRemoveUntil(context, '/screens/homeCliente/home_cliente_page', (route) => false);
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                          content: Text('Proposta Finalizada com Sucesso!',textAlign:TextAlign.center, style: TextStyle(fontSize: 22, color: Colors.white)),
                                          backgroundColor:Colors.greenAccent,duration: Duration(milliseconds: 2300),
                                        ));
                                      } else{
                                        print("Erro");
                                      }
                                    },
                                    child: Text('Sim'),
                                  ),
                                ],
                              ),
                            );    
                          }
                      ),
                    ])
              ]):
              Column(
                children: [
                  Center(child: Text("Corrida não Iniciada!", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold))),
                  SizedBox(height: 10),
                  Center(child: Text("Nenhum Veículo foi selecionado\npor enquanto!", style: TextStyle(fontSize: 17,), textAlign: TextAlign.center,)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PropostasAtivasPage extends StatefulWidget {
  const PropostasAtivasPage({Key? key}) : super(key: key);

  @override
  State<PropostasAtivasPage> createState() => _PropostasAtivasPageState();
}

class _PropostasAtivasPageState extends State<PropostasAtivasPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text("Propostas Ativas"), centerTitle: true, automaticallyImplyLeading: false),
        body: Center(
          child: FutureBuilder<List<PropostaAtivaCliente>>(
            future:  downloadJSONPropostasAtivasC(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<PropostaAtivaCliente> propostasAtivasC = snapshot.requireData.toList();
                if(propostasAtivasC.toString() == "[]"){
                  return Text("Não existe nenhuma Proposta Ativa!", style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold));
                }
                return CustomListView(propostasAtivasC);
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