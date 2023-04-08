// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, use_build_context_synchronously 
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projetotcc/model/url.dart';
import 'package:projetotcc/screens/homeMotorista/perfil_page.dart';
import 'package:projetotcc/services/VerificarToken.dart';
import 'dart:convert';
import 'package:projetotcc/screens/homeMotorista/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class CadastroVeiculoPage extends StatefulWidget {
  const CadastroVeiculoPage({ Key? key }) : super(key: key);

  @override
  State<CadastroVeiculoPage> createState() => _CadastroVeiculoPageState();
}

class _CadastroVeiculoPageState extends State<CadastroVeiculoPage> {
  
  final _formKey = GlobalKey<FormState>();
  String? PlacaRepetida;
  
  Future<bool> cadastroVeiculo() async{
    // Aqui precisa mudar o endereço:
    var url = Uri.parse('http://'+localhost+'/api_tcc/Veiculo/criarveiculo.php');
    var resposta = await http.post(
        url,
        body: {
          'DataImagem': imagedata,
          'NomeImagem': imagename,
          'IDUsuario': idUsuario.toString(),
          'Descricao': descricaoVeiculoC.text,
          'Placa': placaC.text,
          'Modelo': modeloC.text,
          'Ano': anoC.text,
          'PossuiSeguro': possuiSeguro.toString(),
          'PossuiRefrigeracao': possuiRefrigeracao.toString(),
        },
    );
    var data = json.decode(resposta.body);
    if (resposta.statusCode == 200 && data['Retorno'] == "Success") {
      return true;
    }else if (resposta.statusCode == 200 && data['Retorno'] == "Placa repetida") {
      PlacaRepetida = data['Retorno'].toString();
      return false;
    }else{
      return false;
    }
  }

  limparCampos(){
    setState(() {
      descricaoVeiculoC.clear();
      placaC.clear();
      modeloC.clear();
      anoC.clear();
      possuiSeguro = false;
      possuiRefrigeracao = false;
      imagepath = null;
      imagedata = null;
      imagename = null;
      imagem();    
    });
  }

  File? imagepath;
  String? imagename;
  String? imagedata;
  ImagePicker imagePicker = ImagePicker();
  Future<void> pickImage(ImageSource source) async{
    try {
      var getimage = await imagePicker.pickImage(source: source);
      setState(() {
        imagepath = File(getimage!.path);
        imagename = getimage.path.split('/').last;
        imagedata = base64Encode(imagepath!.readAsBytesSync());
      });
    } on PlatformException catch (e) {
      print("falha ao pegar imagem: $e");
    }
  }

  imagem(){
    return imagepath != null 
      ? Image.file(
      imagepath!,
      width: 200,
      height: 200,
      fit: BoxFit.fill,
      ) 
      : Image.asset("assets/caminhao.jpg",fit: BoxFit.fill,width: 200,height: 200);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            children: <Widget>[
              Row(children: [
                  IconButton(
                    onPressed: (){
                      limparCampos();
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => VeiculosPage()));
                    }, 
                    icon: Icon(Icons.arrow_back),
                  )
              ]),
              Text(
                "Cadastre o seu Veículo", textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 42, 
                ),
              ),
              SizedBox(height: 40),
              Text("Selecione uma foto:",style: TextStyle(fontSize: 22)),
              SizedBox(height: 10),
              InkWell(
                onTap: ()=> showModalBottomSheet(context: context,
                  builder: (BuildContext context) {
                    return SafeArea(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            leading:  Icon(Icons.camera_alt_outlined, size:28, color: Colors.black),
                            title:  Text('Camera', style: TextStyle(fontSize: 20)),
                            onTap: ()=>{
                              pickImage(ImageSource.camera),
                              Navigator.pop(context)
                            }
                          ),
                          ListTile(
                            leading:  Icon(Icons.image, size:28, color: Colors.black),
                            title:  Text('Galeria', style: TextStyle(fontSize: 20)),
                            onTap: ()=>{
                              pickImage(ImageSource.gallery),
                              Navigator.pop(context)
                            }
                          ),
                          ListTile(
                            leading:  Icon(Icons.close, size:28, color: Colors.black),
                            title:  Text('Remover foto', style: TextStyle(fontSize: 20)),
                            onTap: ()=>{
                              setState(() {
                                imagepath = null;
                                imagedata = null;
                                imagename = null;
                              }),
                              Navigator.pop(context)
                            }
                          ),
                        ],
                      ),
                    );
                  }
                ),
                child: imagem()
              ),
              SizedBox(height: 10),
              Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(width: 340, height: 145, child: buildDescricao()),
                    Container(width: 340, height: 90, child: buildPlaca()),
                    Container(width: 340, height: 120, child: buildModelo()),
                    Container(width: 340, height: 81, child: buildAno()),
                    Row(children: [SizedBox(width: 30),
                      Checkbox(
                          activeColor: Colors.black87,
                          value: possuiSeguro,
                          onChanged: (bool? value) {
                            setState(() {
                              possuiSeguro = value!;
                            });
                          },
                        ),
                        Text("Possui Seguro",style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ]),
                    Row(children: [SizedBox(width: 30),
                      Checkbox(
                          activeColor: Colors.black87,
                          value: possuiRefrigeracao,
                          onChanged: (bool? value) {
                            setState(() {
                              possuiRefrigeracao = value!;
                            });
                          },
                        ),
                        Text("Possui Refrigeração",style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ])
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.grey),
                  borderRadius: BorderRadius.all(Radius.circular(57)),
                  color: Color.fromARGB(255, 0, 140, 255),
                ),
                width: 340,
                height: 50,
                child: TextButton(child: Text('Cadastrar Veículo', style: TextStyle(color: Colors.black, fontSize: 25)),onPressed: () async{
                    if (!_formKey.currentState!.validate()) {
                      return;
                    } else {
                      if(imagedata == null && imagename == null){
                        imagedata = "não possui foto";
                        imagename = "Fotonãoexistente";
                      }
                      bool deuCerto = await cadastroVeiculo();
                      if(deuCerto == true){
                        setState(() {
                          limparCampos();
                        }); 
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Veículo Cadastrado com Sucesso!',textAlign:TextAlign.center, style: TextStyle(fontSize: 22, color: Colors.white)),
                          backgroundColor:Colors.greenAccent,duration: Duration(milliseconds: 2500),
                        )); 
                        Navigator.pushReplacementNamed(context, '/screens/homeMotorista/perfil_page');
                      }else if(deuCerto == false && PlacaRepetida == "Placa repetida"){
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Já existe um veículo cadastrado com essa placa!',textAlign:TextAlign.center, style: TextStyle(fontSize: 22, color: Colors.white)),
                          backgroundColor:Color.fromARGB(255, 245, 82, 82),duration: Duration(milliseconds: 2500),
                        )); 
                        PlacaRepetida = "";
                      }else{
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Erro ao Cadastrar Veículo. \nTente novamente!',textAlign:TextAlign.center, style: TextStyle(fontSize: 22, color: Colors.white)),
                          backgroundColor:Color.fromARGB(255, 245, 82, 82),duration: Duration(milliseconds: 2500),
                        ));
                      }  
                    }
                  }
                )),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}