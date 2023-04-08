// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last, use_build_context_synchronously, sized_box_for_whitespace
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:projetotcc/model/url.dart';
import 'package:projetotcc/services/VerificarToken.dart';
import 'widgets.dart';
import 'package:http/http.dart' as http;

class CriarPropostaPage extends StatefulWidget {
  const CriarPropostaPage({ Key? key }) : super(key: key);

  @override
  State<CriarPropostaPage> createState() => _CriarPropostaPageState();
}

class _CriarPropostaPageState extends State<CriarPropostaPage> {

  final _formKey = GlobalKey<FormState>();
  String dataE = "Selecione a data";
  String dataR = "Selecione a data";
  DateTime dateTimeR = DateTime.now();
  DateTime dateTimeE = DateTime.now();
  bool possuiSeguro = false;
  bool precisaRefrigeracao = false;
  bool? compararDatas;
  bool? deuCerto;

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
      await criarproposta();
      if(deuCerto == true){
        limparCampos();   
      }
    }
  }

  Future criarproposta() async {
    // Aqui precisa mudar o endereço:
    var url = Uri.parse('http://'+localhost+'/api_tcc/PropostaCriada/criarproposta.php');
    var resposta = await http.post(url, 
    headers: {'Charset': 'utf-8'},
    body:   
    {
      'IDUsuario': idUsuario.toString(),
      'TipoProduto': dropValueProduto.value.toString(),
      'TipoCarga': dropValueCarga.value.toString(),
      'TipoVeiculo': dropValueVeiculo.value.toString(),
      'Descricao': descricaoC.text,
      'DataRetirada': dataR.toString(),
      'DataEntrega': dataE.toString(),
      'Origem': origemC.text,
      'Destino': destinoC.text,
      'Massa': massaC.text,
      'Unidade': dropValueUnidade.value.toString(),
      'Quantidade': quantidadeC.text,
      'TemSeguro': possuiSeguro.toString(),
      'PrecisaSerRefrigerado': precisaRefrigeracao.toString(),
      'Valor': valorC.text,
    });
    var data = json.decode(resposta.body);
    if (resposta.statusCode == 200 && data['Retorno'] == "Success") {
      deuCerto = true;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Sucesso ao criar proposta, vá em propostas criadas para vê-la!',textAlign:TextAlign.center, style: TextStyle(fontSize: 22, color: Colors.white)),
        backgroundColor:Colors.greenAccent,duration: Duration(milliseconds: 4000),
      )); 
    }else{
      deuCerto = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Erro ao criar proposta, tente novamente!',textAlign:TextAlign.center, style: TextStyle(fontSize: 22, color: Colors.white)),
        backgroundColor:Color.fromARGB(255, 245, 82, 82),duration: Duration(milliseconds: 4000),
      ));   
    }
  }  

  limparCampos(){
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
  }  
 
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text("Criar Nova Proposta"),centerTitle: true),
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
                      value: (value.isEmpty ? null : value),
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
                      value: (value.isEmpty ? null : value),
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
                      value: (value.isEmpty ? null : value),
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
                      child: Text(dataR, style: TextStyle(fontSize: 20, color: Colors.black)),
                      onPressed: pickDateTimeR,
                    )
                  ],
                ),
                Row(children:[
                    SizedBox(width: 27),
                    Text("Data de Entrega: ",style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(width: 17),
                    TextButton(
                      child: Text(dataE, style: TextStyle(fontSize: 20, color: Colors.black)),
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
                    SizedBox(width: 18),
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
                      value: (value.isEmpty ? null : value),
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
                      'Criar Proposta',
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