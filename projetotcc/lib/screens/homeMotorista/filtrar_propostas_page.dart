// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last, sized_box_for_whitespace
import 'package:flutter/material.dart';
import 'package:projetotcc/screens/homeMotorista/home_motorista_page.dart';
import 'widgets.dart';

String? possuiSeguroS = "false1";
String? precisaRefrigeracaoS = "false1";
bool possuiumSeguro = false;
bool precisadeRefrigeracao = false;

class FiltrarPropostaPage extends StatefulWidget {
  const FiltrarPropostaPage({ Key? key }) : super(key: key);

  @override
  State<FiltrarPropostaPage> createState() => _FiltrarPropostaPageState();
}

class _FiltrarPropostaPageState extends State<FiltrarPropostaPage> {

  DateTime dateTimeR = DateTime.now();
  DateTime dateTimeE = DateTime.now();
  bool? compararDatas;

  limparCampos(){
    setState(() =>{ 
        dropValueProduto.value = "",
        dropValueCarga.value = "",
        dropValueVeiculo.value = "",
        origemC.text = "",
        destinoC.text = "",
        quantidadeC.text = "",
        massaC.text = "",
        dropValueUnidade.value = "",
        valorC.text = "",
        dataR = "Selecione a data",
        dataE = "Selecione a data",
        possuiSeguroS = "false1",
        precisaRefrigeracaoS = "false1",  
        possuiumSeguro = false,
        precisadeRefrigeracao = false,
      });
  }  

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text("Filtrar Propostas"),centerTitle: true, automaticallyImplyLeading: false, leading: IconButton(
          onPressed: (){
            indexglobal = 1;
            Navigator.pop(context);
          }, 
          icon: Icon(Icons.arrow_back),
        )),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 25),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(370, 40),
                      primary: Colors.lightBlue,
                      textStyle: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold)
                    ),
                    child: Text("Limpar Filtros",style: TextStyle(fontSize: 20)),
                    onPressed: (){
                      limparCampos();
                      indexglobal = 1;
                      Navigator.pushNamedAndRemoveUntil(context, '/screens/homeMotorista/home_motorista_page', (route) => false);
                    }
                  ),
                  SizedBox(height: 25),
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
                      items: dropOpcoesUnidade.map((op) => DropdownMenuItem(value: op,child: Text(op),),).toList()));
                })]),
                Row(children: [
                    SizedBox(width: 10),
                    Checkbox(
                      activeColor: Colors.black,
                      value: possuiumSeguro,
                      onChanged: (bool? value) {setState(() {possuiumSeguro = value!; possuiSeguroS = possuiumSeguro.toString();});},
                    ),
                    Text("Possui Seguro",style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ]),
                Row(children: [SizedBox(width: 10),
                  Checkbox(
                      activeColor: Colors.black,
                      value: precisadeRefrigeracao,
                      onChanged: (bool? value) {setState(() {precisadeRefrigeracao = value!; precisaRefrigeracaoS = precisadeRefrigeracao.toString();});},
                    ),
                    Text("Possui Refrigeração",style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ]),
                SizedBox(height: 20),
                Container(width: 375, child: buildValor()),   
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(370, 40),
                    primary: Colors.lightBlue,
                    textStyle: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold)
                  ),
                  child: Text("Filtrar",style: TextStyle(fontSize: 20)),
                  onPressed: (){
                    indexglobal = 1;
                    Navigator.pushNamedAndRemoveUntil(context, '/screens/homeMotorista/home_motorista_page', (route) => false); 
                  }
                ),
                SizedBox(height: 35),
                ]
            ),
          ),
        ),
      ),
    );
  }
 
  Future pickDateTimeE() async{
    DateTime? dateE = await pickDateE();
    if(dateE == null) return;

    final dateTimeE = DateTime(
      dateE.year,
      dateE.month,
      dateE.day,

    );
    setState(() => this.dateTimeE = dateTimeE);
    dataE = '${dateTimeE.day}/${dateTimeE.month}/${dateTimeE.year}';
    
  }

  Future<DateTime?> pickDateE() =>  showDatePicker(
    context: context,
    initialDate: dateTimeE,
    firstDate: DateTime.now(),
    lastDate: DateTime(dateTimeE.year+5)
  );

  Future pickDateTimeR() async{
    DateTime? dateR = await pickDateR();
    if(dateR == null) return;

    final dateTimeR = DateTime(
      dateR.year,
      dateR.month,
      dateR.day,
    );
    setState(() => this.dateTimeR = dateTimeR);
    dataR = '${dateTimeR.day}/${dateTimeR.month}/${dateTimeR.year}';
   
  }

  Future<DateTime?> pickDateR() =>  showDatePicker(
    context: context,
    initialDate: dateTimeR,
    firstDate: DateTime.now(),
    lastDate: DateTime(dateTimeR.year+5)
  );

}
