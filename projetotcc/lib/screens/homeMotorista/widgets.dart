// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';

String? motoristaID;
final descricaoVeiculoC = TextEditingController();
final placaC = TextEditingController();
final modeloC = TextEditingController();
final anoC = TextEditingController();
bool possuiSeguro = false;
bool possuiRefrigeracao = false;

Widget buildDescricao() {
  return TextFormField(
    decoration: const InputDecoration(
      alignLabelWithHint: true,
      labelText: 'Descrição do Veículo',
      labelStyle: TextStyle(color: Color.fromARGB(255, 88, 88, 88)),
      hintText: 'Digite as informações sobre o veículo',
      prefixIcon: Padding(
        padding: EdgeInsets.only(bottom: 40),
        child: Icon(Icons.description, color: Color.fromARGB(255, 88, 88, 88),size: 20),
      ),
      border: OutlineInputBorder(
         borderRadius: BorderRadius.all(Radius.circular(22)),
         borderSide: BorderSide(color: Color.fromARGB(255, 88, 88, 88)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(22)),
        borderSide: BorderSide(color: Color.fromARGB(255, 88, 88, 88)),
      ),
    ),
    keyboardType: TextInputType.multiline,
    maxLines: 4,
    controller: descricaoVeiculoC,
    validator: (String? value) {
      if (value!.isEmpty) {
        return 'O campo descrição é obrigatório!';
      }
      return null;
    },
  );
}

Widget buildPlaca() {
  return TextFormField(
    decoration: const InputDecoration(
      labelText: 'Placa',
      labelStyle: TextStyle(color: Color.fromARGB(255, 88, 88, 88)),
      hintText: 'Digite a placa do veículo',
      prefixIcon: Icon(Icons.car_rental, color: Color.fromARGB(255, 88, 88, 88),size: 20),
      border: OutlineInputBorder(
         borderRadius: BorderRadius.all(Radius.circular(22)),
         borderSide: BorderSide(color: Color.fromARGB(255, 88, 88, 88)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(22)),
        borderSide: BorderSide(color: Color.fromARGB(255, 88, 88, 88)),
      ),
    ),
    controller: placaC,
    validator: (String? value) {
      if (value!.isEmpty) {
        return 'Esse campo é obrigatório!';
      }
      return null;
    },
  );
}

Widget buildModelo() {
  return TextFormField(
    decoration: InputDecoration(
      alignLabelWithHint: true,
      labelText: 'Modelo',
      labelStyle: TextStyle(color: Color.fromARGB(255, 88, 88, 88)),
      hintText: 'Digite o modelo do Veículo',
      prefixIcon: Padding(
        padding: EdgeInsets.only(bottom: 30),
        child: Icon(Icons.time_to_leave, color: Color.fromARGB(255, 88, 88, 88),size: 20),
      ),
      border: OutlineInputBorder(
         borderRadius: BorderRadius.all(Radius.circular(22)),
         borderSide: BorderSide(color: Color.fromARGB(255, 88, 88, 88)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(22)),
        borderSide: BorderSide(color: Color.fromARGB(255, 88, 88, 88)),
      ),
    ),
    maxLines: 3,
    controller: modeloC,
    validator: (String? value) {
      if (value!.isEmpty) {
        return 'Esse campo é obrigatório!';
      }
      return null;
    },
  );
}

Widget buildAno() {
  return TextFormField(
    decoration: const InputDecoration(
      labelText: 'Ano',
      labelStyle: TextStyle(color: Color.fromARGB(255, 88, 88, 88)),
      hintText: 'Digite o ano do Veículo',
      prefixIcon: Icon(Iconsax.timer, color: Color.fromARGB(255, 88, 88, 88),size: 20),
      border: OutlineInputBorder(
         borderRadius: BorderRadius.all(Radius.circular(22)),
         borderSide: BorderSide(color: Color.fromARGB(255, 88, 88, 88)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(22)),
        borderSide: BorderSide(color: Color.fromARGB(255, 88, 88, 88)),
      ),
    ),
    keyboardType: TextInputType.number,
    controller: anoC,
    validator: (String? value) {
      if (value!.isEmpty) {
        return 'Esse campo é obrigatório!';
      }
      return null;
    },
  );
}

////////////////////////////////////////////////////////
///////////////// Filtrar Proposta: ////////////////////
////////////////////////////////////////////////////////

String dataE = "Selecione a data";
String dataR = "Selecione a data";
final dropValueProduto = ValueNotifier('');
final dropOpcoesProduto = ['Outro tipo de Produto','Alimentos', 'Bebidas', 'Brinquedos', 'Cosméticos','Eletrônicos e Informática', 'Embalagens', 'Líquidos Diversos', 'Máquinas ou Peças em geral', 'Materiais Gráficos', 'Móveis ou Objetos de Escritórios',  'Farmacêuticos', 'Químico', 'Têxtil', 'Veículos', 'Vidros e Lâmpadas', 'Materiais de Construção', 'Estruturas Metálicas e Lonados'];
final dropValueCarga = ValueNotifier('');
final dropOpcoesCarga = ['Outro tipo de Carga','Carga Geral','Carga Granel','Carga NeoGranel','Carga Frigorificada', 'Carga Perigosa'];
final dropValueVeiculo = ValueNotifier('');
final dropOpcoesVeiculo = ['Outro tipo de Veiculo','Truck (médio)','Carreta Toco (pesado)','Carreta LS (pesado)','Rodotrem (pesado)','Bitrem (pesado)','Bi-Truck (médio)','VUC até 4T (leve)','VUC até 2.5T (leve)','VUC até 1.5T (leve)','Tritem (pesado)','Carreta Vanderléia(pesado)','Carro (leve)'];
final origemC = TextEditingController();
final destinoC = TextEditingController();
final massaC = TextEditingController();
final dropValueUnidade = ValueNotifier('');
final dropOpcoesUnidade = ['T','KG'];
final quantidadeC = TextEditingController();
final valorC = TextEditingController();

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
      FilteringTextInputFormatter.digitsOnly
    ],
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
  );
}

Widget buildValor() {
  return TextFormField(
    decoration: const InputDecoration(
      alignLabelWithHint: true,
      counterText: "",
      hintText: 'Digite o Valor Mínimo',
      labelText: 'Valor Mínimo',
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
  );
}

