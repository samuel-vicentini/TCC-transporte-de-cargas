// ignore_for_file: prefer_const_constructors, prefer_interpolation_to_compose_strings, non_constant_identifier_names, use_build_context_synchronously, unused_element, prefer_const_constructors_in_immutables
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:projetotcc/model/propostas_ativas_Motorista.dart';
import 'package:projetotcc/model/url.dart';
import 'package:projetotcc/screens/homeMotorista/home_motorista_page.dart';
import 'package:projetotcc/services/VerificarToken.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:http/http.dart' as http;

Future<List<PropostaAtivaMotorista>> downloadJSONPropostasAtivasM() async {
  var url = Uri.parse('http://'+localhost+'/api_tcc/AceitarProposta/propostasativasM.php');
  var resposta = await http.post(url,
  body: {
    'IDUsuario': idUsuario.toString(),
  });
  if (resposta.statusCode == 200) {
    List propostasAtivasM = json.decode(resposta.body);
    return propostasAtivasM.map((propostasAtivasM) => PropostaAtivaMotorista.fromJson(propostasAtivasM)).toList();
  } else {
    throw Exception('Erro ao recuperar dados!!!');
  }
}

String? IDFretamento;
String? IDProposta;
Future<bool> cancelarCorrida() async {
  var url = Uri.parse('http://'+localhost+'/api_tcc/AceitarProposta/cancelarcorrida.php');
  var resposta = await http.post(url, 
  headers: {'Charset': 'utf-8'},
  body:   
  {
    'IDFretamento': IDFretamento,
    'IDProposta': IDProposta,
  });
  if (resposta.statusCode == 200 && json.decode(resposta.body) == "Success") {
    IDveiculoSelecionado = null;
    return true;
  } else{
    return false;
  }
}

List? veiculosMotorista;
String? IDveiculoSelecionado;
Future downloadJSONVeiculosMotorista() async {
  var url = Uri.parse('http://'+localhost+'/api_tcc/AceitarProposta/veiculosMotorista.php');
  var resposta = await http.post(url,
  body: {
    'IDUsuario': idUsuario.toString(),
  });
  if (resposta.statusCode == 200) {
    veiculosMotorista = json.decode(resposta.body);
  } else {
    throw Exception('Erro ao recuperar dados!!!');
  }
}

Future<bool> iniciarCorrida() async {
  var url = Uri.parse('http://'+localhost+'/api_tcc/AceitarProposta/iniciarcorrida.php');
  var resposta = await http.post(url, 
  headers: {'Charset': 'utf-8'},
  body:   
  {
    'IDFretamento': IDFretamento,
    'IDProposta': IDProposta,
    'IDVeiculo': IDveiculoSelecionado.toString(),
  });
  if (resposta.statusCode == 200 && json.decode(resposta.body) == "Success") {
    IDveiculoSelecionado = null;
    return true;
  } else{
    return false;
  }
}

double? alturaCard;

class CustomListView extends StatefulWidget {
  final List<PropostaAtivaMotorista> propostasAtivasM;
  CustomListView(this.propostasAtivasM);

  @override
  State<CustomListView> createState() => _CustomListViewState();
}
class _CustomListViewState extends State<CustomListView> {
  Widget build(context) {
    downloadJSONVeiculosMotorista(); 
    return ListView.builder(
      itemCount: widget.propostasAtivasM.length,
      itemBuilder: (context, int currentIndex) {
        return createViewItem(widget.propostasAtivasM[currentIndex], context);
      },
    );
  }

  imagemCliente(propostasAtivasM){
    return propostasAtivasM.FotodataCliente.toString() == "../imageupload/Fotonãoexistente"
      ? ClipOval(child: Image.asset("assets/person_add.png",fit: BoxFit.fill,width: 120,height: 120))
      :ClipOval(
        child: Image.network(
        propostasAtivasM.FotoCliente,
        width: 160,
        height: 160,
        fit: BoxFit.fill,
        ),
      );
  }
  
  imagemVeiculo(propostasAtivasM){
    return propostasAtivasM.FotodataVeiculo.toString() == "../imageupload_veiculo/Fotonãoexistente"
      ? ClipOval(child: Image.asset("assets/caminhao.jpg",fit: BoxFit.fill,width: 120,height: 120))
      :ClipOval(
        child: Image.network(
        propostasAtivasM.FotoVeiculo,
        width: 160,
        height: 160,
        fit: BoxFit.fill,
        ),
      );
  }

  Widget createViewItem(PropostaAtivaMotorista propostasAtivasM, BuildContext context) {
    propostasAtivasM.StatusFretamento.toString() == "E" ?
    alturaCard = 1300
    :alturaCard = 1142;
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
              Text(propostasAtivasM.Descricao, style: TextStyle(fontSize: 17)),
              SizedBox(height: 6),
              Center(child: Text("Detalhes da Proposta:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
              SizedBox(height: 9),
              Row(children: [
                Text("Valor a receber: ", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(width: 6),
                Text('R\$ ${propostasAtivasM.Valor}', style: TextStyle(fontSize: 18)),
              ]),
              SizedBox(height: 9),
              Row(children: [
                Text("Tipo do Produto:", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                SizedBox(width: 6),
                Text(propostasAtivasM.TipoProduto, style: TextStyle(fontSize: 16.5)),
              ]),
              SizedBox(height: 9),
              Row(children: [
                Text("Tipo da Carga:", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                SizedBox(width: 6),
                Text(propostasAtivasM.TipoCarga, style: TextStyle(fontSize: 16.5)),
              ]),
              SizedBox(height: 9),
              Row(children: [
                Text("Tipo do Veículo:", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                SizedBox(width: 6),
                Text(propostasAtivasM.TipoVeiculo, style: TextStyle(fontSize: 16.5)),
              ]),
              SizedBox(height: 9),
              Row(children: [
                Text("Quantidade:", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                SizedBox(width: 6),
                Text(propostasAtivasM.Quantidade, style: TextStyle(fontSize: 17)),
              ]),
              SizedBox(height: 9),
              Row(children: [
                Text("Massa:", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                SizedBox(width: 6),
                Text(propostasAtivasM.Massa, style: TextStyle(fontSize: 17)),
                SizedBox(width: 2),
                Text(propostasAtivasM.Unidade, style: TextStyle(fontSize: 17)),
              ]),
              SizedBox(height: 9),
              Row(children: [
                Text("Data de Retirada:", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                SizedBox(width: 6),
                Text(propostasAtivasM.DataRetirada, style: TextStyle(fontSize: 17)),
              ]),
              SizedBox(height: 9),
              Row(children: [
                Text("Data de Entrega:", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                SizedBox(width: 6),
                Text(propostasAtivasM.DataEntrega, style: TextStyle(fontSize: 17)),
              ]),
              SizedBox(height: 9),
              Text("Origem:", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
              SizedBox(height: 6),
              Text(propostasAtivasM.Origem, style: TextStyle(fontSize: 17)),
              SizedBox(height: 9),
              Text("Destino:", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
              SizedBox(height: 6),
              Text(propostasAtivasM.Destino, style: TextStyle(fontSize: 17)),
              SizedBox(height: 9),
              Row(children: [
                Text("Possui Seguro:", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                SizedBox(width: 6),
                Text(propostasAtivasM.TemSeguro == "true" ? "Sim" : "Não", style: TextStyle(fontSize: 17)),
              ]),
              SizedBox(height: 9),
              Row(children: [
                Text("Precisa de Refrigeração:", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                SizedBox(width: 6),
                Text(propostasAtivasM.PrecisaSerRefrigerado == "true" ? "Sim" : "Não", style: TextStyle(fontSize: 17)),
              ]),  
              SizedBox(height: 8),
              Divider(color: Colors.black, thickness: 1),
              SizedBox(height: 7),
              Center(child: Text("Cliente:", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold))),
              SizedBox(height: 20),
              Center(child: imagemCliente(propostasAtivasM)),
              SizedBox(height: 15),
              Row(children: [
                Text("Nome: ", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                SizedBox(width: 6),
                Text(propostasAtivasM.NomeCliente, style: TextStyle(fontSize: 17)),
              ]),
              SizedBox(height: 9),
              Row(children: [
                Text("Telefone: ", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                SizedBox(width: 6),
                Text(propostasAtivasM.TelefoneCliente, style: TextStyle(fontSize: 17)),
              ]),
              SizedBox(height: 9),
              Row(children: [
                Text("E-mail: ", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(width: 6),
                Text(propostasAtivasM.EmailCliente, style: TextStyle(fontSize: 17)),
              ]),
              SizedBox(height: 2),
              Divider(color: Colors.black, thickness: 1),
              SizedBox(height: 8),
              propostasAtivasM.StatusFretamento.toString() != "E" ? 
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(child: Text("Escolha o seu Veículo:", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold))),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      DropdownButtonHideUnderline(
                        child: DropdownButton(
                          hint: Text("Selecione o Veículo que será usado!",style: TextStyle(color: Colors.black,fontSize: 20), textAlign: TextAlign.center),
                          itemHeight: 130,
                          value: IDveiculoSelecionado,
                          items: veiculosMotorista?.map((item)  {
                            return DropdownMenuItem<String>(
                              alignment: Alignment.center,
                              value: item["ID"]!.toString(),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  item["Foto"].toString() == "../imageupload_veiculo/Fotonãoexistente"
                                  ? Image.asset("assets/caminhao.jpg",fit: BoxFit.fill,width: 120,height: 120)
                                  : Image.network(
                                  'http://'+localhost+'/api_tcc/imageupload_veiculo/'+item["Foto"],  
                                  width: 120,
                                  height: 120,
                                  fit: BoxFit.fill,
                                  ),
                                  SizedBox(width: 10),
                                  SizedBox(width:227,child: Text(item["Descricao"], maxLines: 5, style: TextStyle(fontSize: 20))),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (valor) {
                            setState(() {
                              IDveiculoSelecionado = valor.toString();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ): Column(
                children: [
                  Center(child: Text("Veículo Escolhido:", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold))),
                  SizedBox(height: 12),
                  Center(child: imagemVeiculo(propostasAtivasM)),
                  SizedBox(height: 15),
                  Align(alignment: Alignment.centerLeft,child: Text("Descrição: ", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold))),
                  SizedBox(width: 6),
                  Text(propostasAtivasM.DescricaoVeiculo, style: TextStyle(fontSize: 17)),
                  SizedBox(height: 9),
                  Row(children: [
                    Text("Placa: ", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                    SizedBox(width: 6),
                    Text(propostasAtivasM.PlacaVeiculo, style: TextStyle(fontSize: 17)),
              ])]),
              SizedBox(height: 2),
              Divider(color: Colors.black, thickness: 1),
              propostasAtivasM.StatusFretamento.toString() == "A" ? 
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.lightBlue,
                      textStyle: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold)
                    ),
                    child: Text("Iniciar Corrida",style: TextStyle(fontSize: 20)),
                    onPressed: () async {
                      showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: Text('Iniciar Corrida'),
                          content: Text('Você tem certeza que deseja Iniciar a Corrida?'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('Cancelar'),
                            ),
                            TextButton(
                              onPressed: () async {
                                if(IDveiculoSelecionado.toString() == "null"){
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text('Selecione um Veículo!',textAlign:TextAlign.center, style: TextStyle(fontSize: 22, color: Colors.white)),
                                    backgroundColor:Colors.redAccent,duration: Duration(milliseconds: 2300),
                                  )); 
                                }else{
                                  IDFretamento = propostasAtivasM.IDFretamento.toString();
                                  IDProposta = propostasAtivasM.IDProposta.toString();    
                                  bool deuCerto = await iniciarCorrida();
                                  if(deuCerto){
                                    indexglobal = 0;
                                    Navigator.pushReplacementNamed(context, '/screens/homeMotorista/home_motorista_page');
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                      content: Text('Corrida Iniciada!',textAlign:TextAlign.center, style: TextStyle(fontSize: 22, color: Colors.white)),
                                      backgroundColor:Colors.greenAccent,duration: Duration(milliseconds: 2300),
                                    )); 
                                  } else{
                                    print("Erro");
                                  }   
                                }
                              },
                              child: Text('Sim'),
                            ),
                          ],
                        ),
                      );  
                    }
                  ),
                  SizedBox(width: 5),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.redAccent,
                      textStyle: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold)
                    ),
                    child: Text("Cancelar Corrida",style: TextStyle(fontSize: 20)),
                    onPressed: () async{
                      showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: Text('Cancelar Corrida'),
                          content: Text('Você tem certeza que deseja cancelar essa Corrida?'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'Cancel'),
                              child: Text('Cancelar'),
                            ),
                            TextButton(
                              onPressed: () async {
                                IDFretamento = propostasAtivasM.IDFretamento.toString();
                                IDProposta = propostasAtivasM.IDProposta.toString();    
                                bool deuCerto = await cancelarCorrida();
                                if(deuCerto){
                                  indexglobal = 0;
                                  Navigator.pushNamedAndRemoveUntil(context, '/screens/homeMotorista/home_motorista_page', (route) => false);
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text('Proposta Cancelada!',textAlign:TextAlign.center, style: TextStyle(fontSize: 22, color: Colors.white)),
                                    backgroundColor:Colors.greenAccent,duration: Duration(milliseconds: 2300),
                                  ));
                                  IDveiculoSelecionado = null; 
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
                  )
                ],
              ): Padding(
                padding: EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Corrida em Andamento",style: TextStyle(fontSize: 30.0,color: Colors.black)),
                    SizedBox(width: 2),
                    DefaultTextStyle(
                      style: TextStyle(fontSize: 30.0,color: Colors.black,),
                      child: AnimatedTextKit(
                        repeatForever: true,
                        animatedTexts: [
                          TyperAnimatedText('.....',speed: Duration(seconds: 1)),
                        ]))
                  ],
                ),
              )
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
          child: FutureBuilder<List<PropostaAtivaMotorista>>(
            future:  downloadJSONPropostasAtivasM(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<PropostaAtivaMotorista> propostasAtivasM = snapshot.requireData.toList();
                if(propostasAtivasM.toString() == "[]"){
                  return Text("Nenhuma Proposta Ativa no Momento!", style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold));
                }
                return CustomListView(propostasAtivasM);
              } else if (snapshot.hasError) {
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