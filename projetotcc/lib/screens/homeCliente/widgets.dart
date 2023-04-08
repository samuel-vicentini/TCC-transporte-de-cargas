// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';

bool? compararDatas;
bool? deuCerto;
String? dataE;
String? dataR;
bool? possuiSeguro = false;
bool? precisaRefrigeracao = false;
String? usuarioID;
final descricaoC = TextEditingController();
final dropValueProduto = ValueNotifier('');
final dropOpcoesProduto = ['Outro tipo de Produto','Alimentos', 'Bebidas', 'Brinquedos', 'Cosméticos','Eletrônicos e Informática', 'Embalagens', 'Líquidos Diversos', 'Máquinas ou Peças em geral', 'Materiais Gráficos', 'Móveis ou Objetos de Escritórios',  'Farmacêuticos', 'Químico', 'Têxtil', 'Veículos', 'Vidros e Lâmpadas', 'Materiais de Construção', 'Estruturas Metálicas e Lonados'];
final dropValueCarga = ValueNotifier('');
final dropOpcoesCarga = ['Outro tipo de Carga','Carga Geral','Carga Granel','Carga NeoGranel','Carga Frigorificada', 'Carga Perigosa'];
final dropValueVeiculo = ValueNotifier('');
final dropOpcoesVeiculo = ['Outro tipo de Veiculo','Truck (médio)','Carroceria de Bebidas (médio)','Carreta Toco (pesado)','Carreta LS (pesado)','Rodotrem (pesado)','Bitrem (pesado)','Bi-Truck (médio)','VUC até 4T (leve)','VUC até 2.5T (leve)','VUC até 1.5T (leve)','Tritem (pesado)','Carreta Vanderléia(pesado)','Carro (leve)'];
final origemC = TextEditingController();
final destinoC = TextEditingController();
final massaC = TextEditingController();
final dropValueUnidade = ValueNotifier('');
final dropOpcoesUnidade = ['T','KG'];
final quantidadeC = TextEditingController();
final valorC = TextEditingController();

Widget buildDescricao() {
  return TextFormField(
    decoration: InputDecoration(
      alignLabelWithHint: true,
      labelText: 'Descrição da Proposta',
      labelStyle: TextStyle(color: Colors.black),
      hintText: 'Digite as informações da proposta',
      prefixIcon: Padding(
        padding: EdgeInsets.only(bottom: 40),
        child: Icon(Icons.description, color: Colors.black87,size: 24),
      ),
      border: OutlineInputBorder(
         borderRadius: BorderRadius.all(Radius.circular(10)),
         borderSide: BorderSide(color: Color.fromARGB(255, 88, 88, 88)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(color: Color.fromARGB(255, 88, 88, 88)),
      ),
    ),
    keyboardType: TextInputType.multiline,
    maxLines: 3,
    controller: descricaoC,
    validator: (String? value) {
      if (value!.isEmpty) {
        return 'O campo descrição é obrigatório!';
      }
      return null;
    },
  );
}

Widget buildOrigem() {
  return TextFormField(
    decoration: const InputDecoration(
      alignLabelWithHint: true,
      labelText: 'Endereço de Origem',
      labelStyle: TextStyle(color: Colors.black),
      hintText: 'Digite o endereço completo',
      prefixIcon: Padding(
        padding: EdgeInsets.only(bottom: 40),
        child: Icon(Icons.location_pin,color: Colors.black87,size: 24),
      ),
      border: OutlineInputBorder(
         borderRadius: BorderRadius.all(Radius.circular(10)),
         borderSide: BorderSide(color: Color.fromARGB(255, 88, 88, 88)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(color: Color.fromARGB(255, 88, 88, 88)),
      ),
    ),
    keyboardType: TextInputType.multiline,
    maxLines: 3,
    controller: origemC,
    validator: (String? value) {
      if (value!.isEmpty) {
        return 'O campo origem é obrigatório!';
      }
      return null;
    },
    );
}

Widget buildDestino() {
  return TextFormField(
    decoration: const InputDecoration(
      alignLabelWithHint: true,
      labelText: 'Endereço do Destino',
      labelStyle: TextStyle(color: Colors.black),
      hintText: 'Digite o endereço completo',
      prefixIcon: Padding(
        padding: EdgeInsets.only(bottom: 40),
        child: Icon(Icons.location_pin, color: Colors.black87,size: 24),
      ),
      border: OutlineInputBorder(
         borderRadius: BorderRadius.all(Radius.circular(10)),
         borderSide: BorderSide(color: Color.fromARGB(255, 88, 88, 88)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(color: Color.fromARGB(255, 88, 88, 88)),
      ),
    ),
    keyboardType: TextInputType.multiline,
    maxLines: 3,
    controller: destinoC,
    validator: (String? value) {
      if (value!.isEmpty) {
        return 'O campo destino é obrigatório!';
      }
      return null;
    },
  );
}

Widget buildMassa() {
  return TextFormField(
    decoration: const InputDecoration(
      alignLabelWithHint: true,
      counterText: "",
      labelText: 'Massa',
      hintText: 'Digite a Massa',
      labelStyle: TextStyle(color: Colors.black),
      prefixIcon: Icon(Iconsax.weight_15, color: Colors.black87,size: 29),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(color: Color.fromARGB(255, 88, 88, 88)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(color: Color.fromARGB(255, 88, 88, 88)),
      ),   
    ),
    maxLength: 10,
    controller: massaC,
    keyboardType: TextInputType.number,
    inputFormatters: [
      FilteringTextInputFormatter.digitsOnly,
    ],
    validator: (String? value) {
      if (value!.isEmpty) {
        return 'o campo massa é obrigatório!';
      }
      return null;
    },
  );
}

Widget buildQuantidade() {
  return TextFormField(
    decoration: const InputDecoration(
      alignLabelWithHint: true,
      counterText: "",
      hintText: 'Digite a quantidade',
      labelText: 'Quantidade',
      labelStyle: TextStyle(color: Colors.black),
      prefixIcon: Icon(Icons.shopping_cart, color: Colors.black87,size: 29),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(color: Color.fromARGB(255, 88, 88, 88)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(color: Color.fromARGB(255, 88, 88, 88)),
      ),   
    ),
    maxLength: 10,
    controller: quantidadeC,
    keyboardType: TextInputType.number,
    validator: (String? value) {
      if (value!.isEmpty) {
        return 'O campo quantidade é obrigatório!';
      }
      return null;
    },
  );
}

Widget buildValor() {
  return TextFormField(
    decoration: const InputDecoration(
      alignLabelWithHint: true,
      counterText: "",
      hintText: 'Digite o Valor da Proposta',
      labelText: 'Valor da Entrega',
      labelStyle: TextStyle(color: Colors.black),
      suffixIcon: Icon(Icons.attach_money_outlined, color: Colors.black87,size: 29),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(color: Color.fromARGB(255, 88, 88, 88)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(color: Color.fromARGB(255, 88, 88, 88)),
      ),   
    ),
    style: TextStyle(fontSize: 20),
    maxLength: 11,
    controller: valorC,
    keyboardType: TextInputType.number,
    validator: (String? value) {
      if (value!.isEmpty) {
        return 'O campo valor é obrigatório!';
      }
      return null;
    },
  );
}