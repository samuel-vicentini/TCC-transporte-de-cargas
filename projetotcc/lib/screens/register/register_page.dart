// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, sort_child_properties_last, use_build_context_synchronously 
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projetotcc/model/url.dart';
import 'dart:convert';
import 'widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  final _formKey = GlobalKey<FormState>();
  
  validar() async{
    if(!_formKey.currentState!.validate() || groupValue == ""){
      if(!_formKey.currentState!.validate() && groupValue == ""){
        setState(() {
          errorColor = true;
          mudarCor();
        });
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor, Insira as informações corretamente!',textAlign:TextAlign.center, style: TextStyle(fontSize: 22, color: Colors.white)),
          backgroundColor:Color.fromARGB(255, 245, 82, 82),duration: Duration(milliseconds: 2500),
        ));
        return;    
      } else if(groupValue == ""){
        setState(() {
          errorColor = true;
          mudarCor();
        });
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor, Selecione o seu Perfil!',textAlign:TextAlign.center, style: TextStyle(fontSize: 22, color: Colors.white)),
          backgroundColor:Color.fromARGB(255, 245, 82, 82),duration: Duration(milliseconds: 2500),
        ));
        return;
      }else{
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor, Insira as informações corretamente!',textAlign:TextAlign.center, style: TextStyle(fontSize: 22, color: Colors.white)),
          backgroundColor:Color.fromARGB(255, 245, 82, 82),duration: Duration(milliseconds: 2500),
        ));
        return;
      }
    } else{ 
      _formKey.currentState!.save();
      if(imagedata == null && imagename == null){
        imagedata = "não possui foto";
        imagename = "Fotonãoexistente";
      }
      await register();
      if (emailRepetido == "") {
        setState(() {
          limparCampos();
        });    
        Navigator.pushReplacementNamed(context, '/screens/register/success_page');     
      } else{
        emailRepetido = "";
        return;
      }
    }
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

  String? emailRepetido = "";
  Future register() async {
    // Aqui precisa mudar o endereço:
    var url = Uri.parse('http://'+localhost+'/api_tcc/Cadastro/register.php');
    var resposta = await http.post(url, 
    headers: {'Charset': 'utf-8'},
    body:   
    {
      'Nome': nomeC.text,
      'Email': emailC.text,
      'Senha': senhaC.text,
      'DataImagem': imagedata.toString(),
      'NomeImagem': imagename.toString(),
      'Telefone': telefoneC.text,
      'Cpf': cpfC.text,
      'Estado': estadoC.text.toUpperCase(),
      'Cidade': cidadeC.text,
      'Bairro': bairroC.text,
      'Endereco': enderecoC.text,
      'Cep': cepC.text,
      'GroupValue': groupValue.toString(),
    });
    var data = json.decode(resposta.body);
    if (resposta.statusCode == 200 && data['Retorno'] == "Success") {}
    else if (resposta.statusCode == 200 && data['Retorno'] == "Ja existe esse email") {
      emailRepetido = data['Retorno'].toString();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Já existe uma conta registrada nesse e-mail',textAlign:TextAlign.center, style: TextStyle(fontSize: 22, color: Colors.white)),
        backgroundColor:Color.fromARGB(255, 245, 82, 82),duration: Duration(milliseconds: 2500),
      )); 
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Erro ao Cadastrar. \nTente novamente!',textAlign:TextAlign.center, style: TextStyle(fontSize: 22, color: Colors.white)),
        backgroundColor:Color.fromARGB(255, 245, 82, 82),duration: Duration(milliseconds: 2500),
      ));
    }
  }

  bool errorColor = false;
  Color mudarCor(){
    if(errorColor == true){
      return Colors.red;
    }else{
      return Colors.black;
    }
  } 
  
  imagem(){
    return imagepath !=null 
      ? ClipOval(
        child: Image.file(
        imagepath!,
        width: 160,
        height: 160,
        fit: BoxFit.fill,
        ),
      ) 
      : ClipOval(child: Image.asset("assets/person_add.png",fit: BoxFit.fill,width: 160,height: 160));
  }

  limparCampos(){
   setState(() {
    nomeC.clear();
    emailC.clear();
    senhaC.clear();
    telefoneC.clear();
    cpfC.clear();
    estadoC.clear();
    cidadeC.clear();
    bairroC.clear();
    enderecoC.clear();
    cepC.clear();
    imagepath = null;
    imagedata = null;
    imagename = null;
    imagem();
    groupValue = "";
   });
  }

  bool _isVisible = false;
  void updateStatus() {
    setState(() {
      _isVisible = !_isVisible;
    });
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
                      Navigator.pushReplacementNamed(context, '/screens/login/login_page');
                    }, 
                    icon: Icon(Icons.arrow_back),
                  )
              ]),
              Text(
                "Cadastro",
                style: TextStyle(
                  fontSize: 42,
                ),
              ),
              SizedBox(height: 40),
              Text("Selecione o seu perfil:",style: TextStyle(fontSize: 22)),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Radio(
                    fillColor: MaterialStateColor.resolveWith((states) => mudarCor()), 
                    value: "Cliente", 
                    groupValue: groupValue, 
                    onChanged: (value){
                      setState(() {
                        errorColor = false;
                        mudarCor();
                        groupValue = value as String;
                      });
                    }),
                  Text("Cliente",style: TextStyle(fontSize: 20, color: mudarCor())),
                  SizedBox(width:15),
                  Radio(
                    fillColor: MaterialStateColor.resolveWith((states) => mudarCor()), 
                    value: "Motorista", 
                    groupValue: groupValue, 
                    onChanged: (value){
                      setState(() {
                          errorColor = false;
                          mudarCor();
                          groupValue = value as String;
                      });
                    }
                  ),
                  Text("Motorista",style: TextStyle(fontSize: 20, color: mudarCor())),
                ],
              ),
              SizedBox(height: 20),
              Text("Foto de perfil:",style: TextStyle(fontSize: 20)),
              SizedBox(height: 10),
              ClipOval(
                child: InkWell(
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
              ),
              SizedBox(height: 30),
              Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(width: 340, height: 90, child: buildNome()),
                    Container(width: 340, height: 90, child: buildEmail()),
                    Container(
                      width: 340,
                      height: 90, 
                      child: TextFormField(
                        obscureText: _isVisible ? false : true,
                        decoration:  InputDecoration(
                          labelText: "Senha",
                          labelStyle: TextStyle(color: Color.fromARGB(255, 88, 88, 88)),
                          hintText: "Digite sua senha",
                          prefixIcon: const Icon(Icons.lock, color: Color.fromARGB(255, 88, 88, 88),size: 19),
                          suffixIcon: IconButton(
                            onPressed: () => updateStatus(),
                            icon: Icon(_isVisible ? Icons.visibility : Icons.visibility_off),
                            iconSize: 19,
                            color: Color.fromARGB(255, 88, 88, 88),
                          ),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(22)),
                            borderSide: BorderSide(color: Color.fromARGB(255, 88, 88, 88)),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(22)),
                            borderSide: BorderSide(color: Color.fromARGB(255, 88, 88, 88)),
                          ),
                        ),
                        controller: senhaC,
                        keyboardType: TextInputType.visiblePassword,
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'O campo senha é obrigatório!';
                          }
                          return null;
                        },
                      )
                    ),
                    Container(width: 340, height: 90, child: buildTelefone()),
                    Container(width: 340, height: 90, child: buildCPF()),
                    Container(width: 340, height: 90, child: buildEstado()),
                    Container(width: 340, height: 90, child: buildCidade()),
                    Container(width: 340, height: 90, child: buildBairro()),
                    Container(width: 340, height: 90, child: buildEndereco()),
                    Container(width: 340, height: 90, child: buildCEP()),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.grey),
                  borderRadius: BorderRadius.all(Radius.circular(57)),
                  color: Color.fromARGB(255, 0, 140, 255),
                ),
                width: 340,
                height: 50,
                child: TextButton(child: Text('Cadastrar', style: TextStyle(color: Colors.black, fontSize: 25)),onPressed: validar
                )),
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Já possui uma conta?", style: TextStyle(fontSize: 17)),
                  TextButton(
                    child: const Text("Faça Login!", style: TextStyle(fontSize: 17)),
                    onPressed: (){
                      limparCampos();
                      Navigator.pushReplacementNamed(context, '/screens/login/login_page');
                    },
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}