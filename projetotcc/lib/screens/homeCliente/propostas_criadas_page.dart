// ignore_for_file: prefer_const_constructors, sort_child_properties_last, use_build_context_synchronously
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:projetotcc/model/propostas_criadas.dart';
import 'package:projetotcc/model/url.dart';
import 'package:projetotcc/screens/homeCliente/home_cliente_page.dart';
import 'package:projetotcc/services/VerificarToken.dart';
import 'widgets.dart';

String? ID;
Future excluirProposta() async {
  // Aqui precisa mudar o endereço:
  var url = Uri.parse('http://'+localhost+'/api_tcc/PropostaCriada/excluirproposta.php');
  var resposta = await http.post(url, 
  headers: {'Charset': 'utf-8'},
  body:   
  {
    'IDProposta': ID,
  });
  if (resposta.statusCode != 200) {
    throw Exception('Erro ao excluir proposta!');
  }
}

Future<List<PropostasCriadas>> downloadJSON() async {
  // Aqui precisa mudar o endereço:
  var url = Uri.parse('http://'+localhost+'/api_tcc/PropostaCriada/propostascriadas.php');
  var resposta = await http.post(url, 
  headers: {'Charset': 'utf-8'},
  body:   
  {
    'IDUsuario': idUsuario.toString(),
  });
  if (resposta.statusCode == 200) {
    List proposta = json.decode(resposta.body);
    return proposta.map((proposta) => PropostasCriadas.fromJson(proposta)).toList();
  } else {
    throw Exception('Erro ao recuperar dados!!!');
  }
}

class CustomListView extends StatefulWidget {
  final List<PropostasCriadas> proposta;
  CustomListView(this.proposta);

  @override
  State<CustomListView> createState() => _CustomListViewState();
}
class _CustomListViewState extends State<CustomListView> {
  Widget build(context) {
    return RefreshIndicator(
      onRefresh: () async{ 
        indexglobal = 1;
        Navigator.pushReplacementNamed(context, '/screens/homeCliente/home_cliente_page');
      },
      child: ListView.builder(
        itemCount: widget.proposta.length,
        itemBuilder: (context, int currentIndex) {
          return createViewItem(widget.proposta[currentIndex], context);
        },
      ),
    );
  }

  Widget createViewItem(PropostasCriadas proposta, BuildContext context) {
    return Card(
      color: Colors.white,
      child: Container(
        height: 646,
        decoration: BoxDecoration(border: Border.all(color: Colors.black54)),
        padding: EdgeInsets.all(3),
        margin: EdgeInsets.all(5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Center(child: Text("Descrição:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
            SizedBox(height: 6),
            Text(proposta.Descricao, style: TextStyle(fontSize: 17)),
            Divider(color: Colors.black, thickness: 1),
            Center(child: Text("Detalhes da Proposta:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
            SizedBox(height: 9),
            Row(children: [
              Text("Valor: ", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(width: 6),
              Text('R\$ ${proposta.Valor}', style: TextStyle(fontSize: 18)),
            ]),
            SizedBox(height: 9),
            Row(children: [
              Text("Tipo do Produto:", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
              SizedBox(width: 6),
              Text(proposta.TipoProduto, style: TextStyle(fontSize: 16.5)),
            ]),
            SizedBox(height: 9),
            Row(children: [
              Text("Tipo da Carga:", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
              SizedBox(width: 6),
              Text(proposta.TipoCarga, style: TextStyle(fontSize: 16.5)),
            ]),
            SizedBox(height: 9),
            Row(children: [
              Text("Tipo do Veículo:", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
              SizedBox(width: 6),
              Text(proposta.TipoVeiculo, style: TextStyle(fontSize: 16.5)),
            ]),
            SizedBox(height: 9),
            Row(children: [
              Text("Quantidade:", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
              SizedBox(width: 6),
              Text(proposta.Quantidade, style: TextStyle(fontSize: 17)),
            ]),
            SizedBox(height: 9),
            Row(children: [
              Text("Massa:", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
              SizedBox(width: 6),
              Text(proposta.Massa, style: TextStyle(fontSize: 17)),
              SizedBox(width: 2),
              Text(proposta.Unidade, style: TextStyle(fontSize: 17)),
            ]),
            Divider(color: Colors.black, thickness: 1),
            Row(children: [
              Text("Data de Retirada:", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
              SizedBox(width: 6),
              Text(proposta.DataRetirada, style: TextStyle(fontSize: 17)),
            ]),
            SizedBox(height: 9),
            Row(children: [
              Text("Data de Entrega:", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
              SizedBox(width: 6),
              Text(proposta.DataEntrega, style: TextStyle(fontSize: 17)),
            ]),
            SizedBox(height: 9),
            Text("Origem:", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            SizedBox(height: 6),
            Text(proposta.Origem, style: TextStyle(fontSize: 17)),
            SizedBox(height: 9),
            Text("Destino:", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            SizedBox(height: 6),
            Text(proposta.Destino, style: TextStyle(fontSize: 17)),
            SizedBox(height: 9),
            Row(children: [
              Text("Possui Seguro:", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
              SizedBox(width: 6),
              Text(proposta.TemSeguro == "true" ? "Sim" : "Não", style: TextStyle(fontSize: 17)),
            ]),
            SizedBox(height: 9),
            Row(children: [
              Text("Precisa de Refrigeração:", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
              SizedBox(width: 6),
              Text(proposta.PrecisaSerRefrigerado == "true" ? "Sim" : "Não", style: TextStyle(fontSize: 17)),
            ]),
            Divider(color: Colors.black, thickness: 1),
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
                  child: Text("Alterar Proposta",style: TextStyle(fontSize: 20)),
                  onPressed: (){
                    descricaoC.text = proposta.Descricao;
                    dropValueProduto.value = proposta.TipoProduto;
                    dropValueCarga.value = proposta.TipoCarga;
                    dropValueVeiculo.value = proposta.TipoVeiculo;
                    dataE = proposta.DataEntrega.toString();
                    dataR = proposta.DataRetirada.toString();
                    origemC.text = proposta.Origem;
                    destinoC.text = proposta.Destino;
                    quantidadeC.text = proposta.Quantidade;
                    massaC.text = proposta.Massa;
                    dropValueUnidade.value = proposta.Unidade;
                    if(proposta.TemSeguro == "true"){
                      possuiSeguro = true;
                    }else{
                      possuiSeguro = false;  
                    }
                    if(proposta.PrecisaSerRefrigerado == "true"){
                      precisaRefrigeracao = true;
                    }else{
                      precisaRefrigeracao = false;  
                    }
                    valorC.text = proposta.Valor;
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AlterarPropostaPage(value: proposta)),
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
                  child: Text("Excluir Proposta",style: TextStyle(fontSize: 20)),
                  onPressed: () async{
                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: Text('Excluir Proposta'),
                        content: Text('Você tem certeza que deseja excluir essa proposta? \n\n(essa ação é permanente!)'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('Cancelar'),
                          ),
                          TextButton(
                            onPressed: () async {
                              ID = proposta.IDProposta.toString();
                              await excluirProposta();
                              indexglobal = 1;
                              Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (BuildContext context) => HomeClientePage()),ModalRoute.withName('/'));
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('Proposta Excluída com Sucesso!',textAlign:TextAlign.center, style: TextStyle(fontSize: 22, color: Colors.white)),
                                backgroundColor:Colors.greenAccent,duration: Duration(milliseconds: 2000),
                              )); 
                            },
                            child: Text('OK'),
                          ),
                        ],
                      ),
                    );
                  }
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class PropostasCriadasPage extends StatefulWidget {
  const PropostasCriadasPage({ Key? key }) : super(key: key);

  @override
  State<PropostasCriadasPage> createState() => _PropostasCriadasPageState();
}
class _PropostasCriadasPageState extends State<PropostasCriadasPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text("Propostas Criadas"), centerTitle: true),
        body: Center(
          child: FutureBuilder<List<PropostasCriadas>>(
            future:  downloadJSON(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<PropostasCriadas> proposta = snapshot.requireData.toList();
                if(proposta.toString() == "[]"){
                  return Text("Você não possui nenhuma Proposta!", style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold));
                }
                return CustomListView(proposta);
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

class AlterarPropostaPage extends StatefulWidget {
  
  final PropostasCriadas value;

  AlterarPropostaPage({required this.value});

  @override
  State<AlterarPropostaPage> createState() => _AlterarPropostaPageState();
}

class _AlterarPropostaPageState extends State<AlterarPropostaPage> {
  
  final _formKey = GlobalKey<FormState>();
  DateTime dateTimeR = DateTime.now();
  DateTime dateTimeE = DateTime.now();
  
  validar() async {
    compararDatas = dateTimeE.isBefore(dateTimeR);
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Digite as informações corretamente!',textAlign:TextAlign.center, style: TextStyle(fontSize: 22, color: Colors.white)),
        backgroundColor:Color.fromARGB(255, 245, 82, 82),duration: Duration(milliseconds: 2000),
      )); 
      return;
    } else if (dataE == "Selecione a data" || dataE == "Selecione a data"){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Selecione as datas corretamente!',textAlign:TextAlign.center, style: TextStyle(fontSize: 22, color: Colors.white)),
        backgroundColor:Color.fromARGB(255, 245, 82, 82),duration: Duration(milliseconds: 2000),
      )); 
      return;  
    }else if (compararDatas == true){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('A data de Retirada deve ser menor do que a de Entrega. Confirme as datas escolhidas!',textAlign:TextAlign.center, style: TextStyle(fontSize: 22, color: Colors.white)),
        backgroundColor:Color.fromARGB(255, 245, 82, 82),duration: Duration(milliseconds: 4000),
      )); 
      return;  
    }else{
      _formKey.currentState!.save();
      await alterarProposta();
      if(deuCerto == true){
        setState(() =>{ 
          descricaoC.clear(),
          dropValueProduto.value = '',
          dropValueCarga.value = '',
          dropValueVeiculo.value = '',
          origemC.clear(),
          destinoC.clear(),
          quantidadeC.clear(),
          massaC.clear(),
          dropValueUnidade.value = '',
          valorC.clear(),
          dataR = "Selecione a data",
          dataE = "Selecione a data",
          possuiSeguro = false,
          precisaRefrigeracao = false,
        });
        indexglobal = 1;
        Navigator.pushReplacementNamed(context, '/screens/homeCliente/home_cliente_page');
      }
    }
  }
  
  Future alterarProposta() async {
    // Aqui precisa mudar o endereço:
    var url = Uri.parse('http://'+localhost+'/api_tcc/PropostaCriada/alterarproposta.php');
    var resposta = await http.post(url, 
    headers: {'Charset': 'utf-8'},
    body:   
    {
      'IDProposta': widget.value.IDProposta.toString(),
      'TipoProduto': dropValueProduto.value.toString(),
      'TipoCarga': dropValueCarga.value.toString(),
      'TipoVeiculo': dropValueVeiculo.value.toString(),
      'Descricao': descricaoC.text.toString(),
      'DataRetirada': dataR.toString(),
      'DataEntrega': dataE.toString(),
      'Origem': origemC.text.toString(),
      'Destino': destinoC.text.toString(),
      'Massa': massaC.text.toString(),
      'Unidade': dropValueUnidade.value.toString(),
      'Quantidade': quantidadeC.text.toString(),
      'TemSeguro': possuiSeguro.toString(),
      'PrecisaSerRefrigerado': precisaRefrigeracao.toString(),
      'Valor': valorC.text.toString(),
    });
    var data = json.decode(resposta.body);
    if (resposta.statusCode == 200) {
      deuCerto = true;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Sucesso ao alterar proposta!',textAlign:TextAlign.center, style: TextStyle(fontSize: 22, color: Colors.white)),
        backgroundColor:Colors.greenAccent,duration: Duration(milliseconds: 4000),
      )); 
    }else{
      deuCerto = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Erro ao alterar proposta, tente novamente!',textAlign:TextAlign.center, style: TextStyle(fontSize: 22, color: Colors.white)),
        backgroundColor:Color.fromARGB(255, 245, 82, 82),duration: Duration(milliseconds: 4000),
      ));   
    }
  }  
    
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text("Alterar Proposta"),centerTitle: true, leading: IconButton(onPressed: () {
          setState(() =>{ 
            descricaoC.clear(),
            dropValueProduto.value = '',
            dropValueCarga.value = '',
            dropValueVeiculo.value = '',
            origemC.clear(),
            destinoC.clear(),
            quantidadeC.clear(),
            massaC.clear(),
            dropValueUnidade.value = '',
            valorC.clear(),
            dataR = "Selecione a data",
            dataE = "Selecione a data",
            possuiSeguro = false,
            precisaRefrigeracao = false,
          });
          indexglobal = 1;
          Navigator.pushReplacementNamed(context, '/screens/homeCliente/home_cliente_page');
        }, icon:Icon(Icons.arrow_back))),
        body: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height:12),
                Text("Digite as informações corretamente!",style: TextStyle(fontSize: 20)),
                SizedBox(height:5),
                Divider(color: Colors.black),
                SizedBox(height: 5),
                Container(width: 375, height: 130, child: buildDescricao()),
                ValueListenableBuilder(valueListenable: dropValueProduto, builder: (BuildContext context, String value, _){return SizedBox(
                    width: 375,
                    height: 93,
                    child: DropdownButtonFormField<String>(
                      isExpanded: true,
                      decoration: InputDecoration(
                        hintText: 'Escolha o Tipo do Produto',
                        hintStyle: TextStyle(color: Colors.black),
                        labelText: 'Tipo do Produto',
                        labelStyle: TextStyle(color: Colors.black),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(color: Color.fromARGB(255, 88, 88, 88))),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(color: Color.fromARGB(255, 88, 88, 88))),  
                      ),
                      value: (value.isEmpty ? null : widget.value.TipoProduto),
                      onChanged: (escolha) => dropValueProduto.value = escolha.toString(),
                      validator: (value) {
                        if (dropValueProduto.value.isEmpty) {
                          return 'O campo tipo do produto é obrigatório!';
                        }
                        return null;
                      },
                      items: dropOpcoesProduto.map((op) => DropdownMenuItem(value: op,child: Text(op),),).toList()));
                }),  
                ValueListenableBuilder(valueListenable: dropValueCarga, builder: (BuildContext context, String value, _){return SizedBox(
                    width: 375,
                    height: 93,
                    child: DropdownButtonFormField<String>(
                      isExpanded: true,
                      decoration: InputDecoration(
                        hintText:"Escolha o Tipo da Carga",
                        hintStyle: TextStyle(color: Colors.black),
                        labelText: 'Tipo da Carga',
                        labelStyle: TextStyle(color: Colors.black),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(color: Color.fromARGB(255, 88, 88, 88))),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(color: Color.fromARGB(255, 88, 88, 88))),  
                      ),
                      value: (value.isEmpty ? null : widget.value.TipoCarga),
                      onChanged: (escolha) => dropValueCarga.value = escolha.toString(),
                      validator: (value) {
                        if (dropValueCarga.value.isEmpty) {
                          return 'O campo tipo da carga é obrigatório!';
                        }
                        return null;
                      },
                      items: dropOpcoesCarga.map((op) => DropdownMenuItem(value: op,child: Text(op),),).toList()));
                }),
                ValueListenableBuilder(valueListenable: dropValueVeiculo, builder: (BuildContext context, String value, _){return SizedBox(
                    width: 375,
                    height: 86,
                    child: DropdownButtonFormField<String>(
                      isExpanded: true,
                      decoration: InputDecoration(
                        hintText: 'Escolha o Tipo do Veículo',
                        hintStyle: TextStyle(color: Colors.black),
                        labelText: 'Tipo do Veículo',
                        labelStyle: TextStyle(color: Colors.black),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(color: Color.fromARGB(255, 88, 88, 88))),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(color: Color.fromARGB(255, 88, 88, 88))),  
                      ),
                      value: (value.isEmpty ? null : widget.value.TipoVeiculo),
                      onChanged: (escolha) => dropValueVeiculo.value = escolha.toString(),
                      validator: (value) {
                        if (dropValueVeiculo.value.isEmpty) {
                          return 'O campo tipo do Veículo é obrigatório!';
                        }
                        return null;
                      },
                      items: dropOpcoesVeiculo.map((op) => DropdownMenuItem(value: op,child: Text(op),),).toList()));
                }),   
                Row(children:[
                    SizedBox(width: 27),
                    Text("Data de Retirada: ",style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(width: 10),
                    TextButton(
                      child: Text(dataR.toString(), style: TextStyle(fontSize: 20, color: Colors.black)),
                      onPressed: pickDateTimeR,
                    )
                  ],
                ),
                Row(children:[
                    SizedBox(width: 27),
                    Text("Data de Entrega: ",style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(width: 17),
                    TextButton(
                      child: Text(dataE.toString(), style: TextStyle(fontSize: 20, color: Colors.black)),
                      onPressed: pickDateTimeE,
                    )
                  ],
                ),
                SizedBox(height: 7),
                Container(width: 375, height: 130, child: buildOrigem()),
                Container(width: 375, height: 130, child: buildDestino()),
                Container(width: 375, height: 90, child: buildQuantidade()),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(width: 20),
                    Container(width: 210, height: 83, child: buildMassa()),
                    SizedBox(width: 20),
                    ValueListenableBuilder(valueListenable: dropValueUnidade, builder: (BuildContext context, String value, _){return SizedBox(
                    width: 145,
                    height: 83,
                    child: DropdownButtonFormField<String>(
                      isExpanded: true,
                      decoration: InputDecoration(
                        hintText: 'Unidade',
                        hintStyle: TextStyle(color: Colors.black),
                        labelText: 'Unidade',
                        labelStyle: TextStyle(color: Colors.black),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(color: Color.fromARGB(255, 88, 88, 88))),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(color: Color.fromARGB(255, 88, 88, 88))),  
                      ),
                      value: (value.isEmpty ? null : widget.value.Unidade),
                      onChanged: (escolha) => dropValueUnidade.value = escolha.toString(),
                      validator: (value) {
                        if (dropValueUnidade.value.isEmpty) {
                          return 'obrigatório!';
                        }
                        return null;
                      },
                      items: dropOpcoesUnidade.map((op) => DropdownMenuItem(value: op,child: Text(op),),).toList()));
                })]),
                Row(children: [
                    SizedBox(width: 10),
                    Checkbox(
                      activeColor: Colors.black,
                      value: possuiSeguro,
                      onChanged: (bool? value) {setState(() {possuiSeguro = value!;});},
                    ),
                    Text("Possui Seguro",style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ]),
                Row(children: [SizedBox(width: 10),
                  Checkbox(
                      activeColor: Colors.black,
                      value: precisaRefrigeracao,
                      onChanged: (bool? value) {setState(() {precisaRefrigeracao = value!;});},
                    ),
                    Text("Possui Refrigeração",style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ]),
                SizedBox(height: 15),
                Container(width: 375, child: buildValor()),   
                SizedBox(height: 35),               
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.grey),
                    borderRadius: BorderRadius.all(Radius.circular(57)),
                    color: Color.fromARGB(255, 0, 140, 255),
                  ),
                  width: 340,
                  height: 50,
                  child: TextButton(
                    child: Text(
                      'Alterar Proposta',
                      style: TextStyle(color: Colors.black, fontSize: 28),
                    ),
                    onPressed: validar
                  ),
                ),
                SizedBox(height: 60),
              ],
            ),
          ),
        ),   
      ),
    );
  }

  Future pickDateTimeE() async{
    DateTime? dateE = await pickDateE();
    if(dateE == null) return;

    TimeOfDay? timeE = await pickTimeE();
    if(timeE == null) return;

    final dateTimeE = DateTime(
      dateE.year,
      dateE.month,
      dateE.day,
      timeE.hour,
      timeE.minute
    );
    setState(() => this.dateTimeE = dateTimeE);
    dataE = '${dateTimeE.day}/${dateTimeE.month}/${dateTimeE.year}  ${timeE.hour}:${timeE.minute}';
    
  }

  Future<DateTime?> pickDateE() =>  showDatePicker(
    context: context,
    initialDate: dateTimeE,
    firstDate: DateTime.now(),
    lastDate: DateTime(dateTimeE.year+5)
  );

  Future<TimeOfDay?> pickTimeE() => showTimePicker(
    context: context,
    initialTime: TimeOfDay(hour: dateTimeE.hour, minute: dateTimeE.minute)
  );


  Future pickDateTimeR() async{
    DateTime? dateR = await pickDateR();
    if(dateR == null) return;

    TimeOfDay? timeR = await pickTimeR();
    if(timeR == null) return;

    final dateTimeR = DateTime(
      dateR.year,
      dateR.month,
      dateR.day,
      timeR.hour,
      timeR.minute
    );
    setState(() => this.dateTimeR = dateTimeR);
    dataR = '${dateTimeR.day}/${dateTimeR.month}/${dateTimeR.year}  ${timeR.hour}:${timeR.minute}';
   
  }

  Future<DateTime?> pickDateR() =>  showDatePicker(
    context: context,
    initialDate: dateTimeR,
    firstDate: DateTime.now(),
    lastDate: DateTime(dateTimeR.year+5)
  );

  Future<TimeOfDay?> pickTimeR() => showTimePicker(
    context: context,
    initialTime: TimeOfDay(hour: dateTimeR.hour, minute: dateTimeR.minute)
  );
}