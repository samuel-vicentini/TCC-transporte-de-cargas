// ignore_for_file: prefer_const_constructors, sort_child_properties_last, use_build_context_synchronously, prefer_const_literals_to_create_immutables, avoid_print
import 'dart:async'; 
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:projetotcc/model/perfil_motorista.dart';
import 'package:projetotcc/model/propostas_finalizadas.dart';
import 'package:projetotcc/model/veiculos.dart';
import 'package:projetotcc/model/url.dart';
import 'package:projetotcc/screens/homeMotorista/home_motorista_page.dart';
import 'package:projetotcc/screens/homeMotorista/widgets.dart';
import 'dart:convert';
import 'package:projetotcc/screens/login/login_page.dart';
import 'package:projetotcc/screens/homeMotorista/cadastro_veiculos_page.dart';
import 'package:projetotcc/screens/register/widgets.dart';
import 'package:projetotcc/services/VerificarToken.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> sair() async{
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  await sharedPreferences.clear();
  idUsuario = "";
  perfil = "";
  token = "";
  return true;
}

Future excluirUsuario() async {
  // Aqui precisa mudar o endereço:
  var url = Uri.parse('http://'+localhost+'/api_tcc/Perfil/excluirusuario.php');
  var resposta = await http.post(url, 
  headers: {'Charset': 'utf-8'},
  body:   
  {
    'IDUsuario': idUsuario.toString(),
  });
  if (resposta.statusCode != 200 && resposta.body == "Erro") {
    throw Exception('Erro ao excluir usuario!');
  }
}

Future<List<Motorista>> downloadJSON() async {
  // Aqui precisa mudar o endereço:
  var url = Uri.parse('http://'+localhost+'/api_tcc/Perfil/perfil.php');
  var resposta = await http.post(url, 
  headers: {'Charset': 'utf-8'},
  body:   
  {
    'IDUsuario': idUsuario.toString(),
  });
  if (resposta.statusCode == 200) {
    List motorista = json.decode(resposta.body);
    return motorista.map((motorista) => Motorista.fromJson(motorista)).toList();
  } else {
    throw Exception('Erro ao recuperar dados!!!');
  }
}

class CustomListView extends StatefulWidget {
  final List<Motorista> motorista;
  CustomListView(this.motorista);

  @override
  State<CustomListView> createState() => _CustomListViewState();
}
class _CustomListViewState extends State<CustomListView> {
  Widget build(context) {
    return ListView.builder(
        itemCount: widget.motorista.length,
        itemBuilder: (context, int currentIndex) {
          return createViewItem(widget.motorista[currentIndex], context);    
        },
      );
  }
  String? fotoAntiga;
  Future trocarFoto() async {
    // Aqui precisa mudar o endereço:
    var url = Uri.parse('http://'+localhost+'/api_tcc/Perfil/trocarfoto.php');
    var resposta = await http.post(
        url,
        body: {
          'DataImagem': imagedata,
          'NomeImagem': imagename,
          'IDUsuario': idUsuario.toString(),
          'FotoAntiga': fotoAntiga.toString(),
        },
    );
    var data = json.decode(resposta.body);
    if (resposta.statusCode == 200 && data['Retorno'] == "Success") {
      imagepath = null;
      imagedata = null;
      imagename = null;
      imagemperfil = "";
      indexglobal = 2;
      Navigator.pushReplacementNamed(context, '/screens/homeMotorista/home_motorista_page');
    }else{
      print("Deu erro");
    }
  }

  File? imagepath;
  String? imagename;
  String? imagedata;
  String? imagemperfil;
  ImagePicker imagePicker = ImagePicker();
  Future<void> pickImage(ImageSource source) async{
    try {
      var getimage = await imagePicker.pickImage(source: source);
      setState(() {
        imagepath = File(getimage!.path);
        imagename = getimage.path.split('/').last;
        imagedata = base64Encode(imagepath!.readAsBytesSync());
        imagemperfil = "";
        trocar();
        
      });
    } on PlatformException catch (e) {
      print("falha ao pegar imagem: $e");
    }
  }

  trocar () async{
    await trocarFoto();
  }

  imagem(motorista){
    return motorista.Fotodata.toString() == "../imageupload/Fotonãoexistente" || imagemperfil == "Fotonãoexistente" 
      ? ClipOval(child: Image.asset("assets/person_add.png",fit: BoxFit.fill,width: 140,height: 140))
      :ClipOval(
        child: Image.network(
        motorista.Foto,
        width: 140,
        height: 140,
        fit: BoxFit.fill,
        ),
      );
  }
  
  Widget createViewItem(Motorista motorista, BuildContext context) {
    downloadJSON();
    fotoAntiga = motorista.Fotodata;
    imagem(motorista);
    return SafeArea(
      child: Column(
        children: [
          SizedBox(height: 35),
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
                        onTap: () {
                          setState(() {
                            if(imagedata == null && imagename == null){
                              imagedata = "não possui foto";
                              imagename = "Fotonãoexistente";
                            }
                            imagemperfil = "Fotonãoexistente";
                            trocarFoto();
                            imagem(motorista);
                          });
                          Navigator.pop(context);
                        }
                      ),
                    ],
                  ),
                );
              }
            ),
            child: imagem(motorista)
          ),
          SizedBox(height: 20),
          Text(motorista.Nome, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Text(motorista.Email, style: TextStyle(fontSize: 17)),
          SizedBox(height: 30),
          InkWell(
            onTap: (){
              nomeC.text = motorista.Nome;
              emailC.text = motorista.Email;
              senhaC.text = motorista.Senha;
              telefoneC.text = motorista.Telefone;
              cpfC.text = motorista.CPF;
              estadoC.text = motorista.Estado;
              cidadeC.text = motorista.Cidade;
              bairroC.text = motorista.Bairro;
              enderecoC.text = motorista.Endereco;
              cepC.text = motorista.CEP;
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AlterarUsuario(value: motorista)));
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.black38),
                borderRadius: BorderRadius.all(Radius.circular(57)),
                color: Color.fromARGB(255, 175, 175, 175),
              ),
              width: 340,
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 15),
                  Icon(Icons.admin_panel_settings_rounded, size: 26),
                  SizedBox(width: 15),
                  Text('Alterar perfil',style: TextStyle(color: Colors.black, fontSize: 26)),
                  SizedBox(width: 100),
                  Icon(Icons.arrow_forward_ios_rounded, size: 26),
                ],
              )
            ),
          ),
          SizedBox(height: 10),
          InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => VeiculosPage()));
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.black38),
                borderRadius: BorderRadius.all(Radius.circular(57)),
                color: Color.fromARGB(255, 175, 175, 175),
              ),
              width: 340,
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 15),
                  Icon(Icons.directions_car_sharp, size: 26),
                  SizedBox(width: 15),
                  Text('Meus Veículos',style: TextStyle(color: Colors.black, fontSize: 26)),
                  SizedBox(width: 70),
                  Icon(Icons.arrow_forward_ios_rounded, size: 26),
                ],
              )
            ),
          ),
          SizedBox(height: 10),
          InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => PropostasFinalizadasPage()));
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.black38),
                borderRadius: BorderRadius.all(Radius.circular(57)),
                color: Color.fromARGB(255, 175, 175, 175),
              ),
              width: 340,
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 15),
                  Icon(Icons.checklist_rounded, size: 26),
                  SizedBox(width: 15),
                  Text('Propostas Entregues', style: TextStyle(color: Colors.black, fontSize: 26)),
                  SizedBox(width: 0),
                  Icon(Icons.arrow_forward_ios_rounded, size: 26),
                ],
              )
            ),
          ),
          SizedBox(height: 10),
          InkWell(
            onTap: ()async{
              showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: Text('Sair dessa conta'),
                  content: Text('Você tem certeza que deseja sair dessa conta?'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'Cancel'),
                      child: Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () async {
                        indexglobal = 0;
                        bool saiu = await sair();
                        if(saiu){
                          Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (BuildContext context) {
                              return TokenPage();
                            },
                          ), (_) => false);
                        }  
                      },
                      child: Text('Sim'),
                    ),
                  ],
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.black38),
                borderRadius: BorderRadius.all(Radius.circular(57)),
                color: Color.fromARGB(255, 175, 175, 175),
              ),
              width: 340,
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 15),
                  Icon(Icons.logout, size: 26),
                  SizedBox(width: 15),
                  Text('Sair dessa conta',style: TextStyle(color: Colors.black, fontSize: 26)),
                ],
              )
            ),
          ),
          SizedBox(height: 30),
          InkWell(
            onTap: () async{
              showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: Text('Excluir Usuário'),
                  content: Text('Você tem certeza que deseja excluir esse usuário? \n\n(essa ação é permanente)'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'Cancel'),
                      child: Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () async {
                        await excluirUsuario();
                        Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (BuildContext context) => LoginPage()),ModalRoute.withName('/'));
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Usuario excluído com sucesso',textAlign:TextAlign.center, style: TextStyle(fontSize: 22, color: Colors.white)),
                          backgroundColor:Colors.greenAccent,duration: Duration(milliseconds: 2300),
                        )); 
                      },
                      child: Text('Sim'),
                    ),
                  ],
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.black38),
                borderRadius: BorderRadius.all(Radius.circular(57)),
                color: Color.fromARGB(255, 253, 96, 96),
              ),
              width: 340,
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 15),
                  Icon(Icons.delete_forever, size: 26),
                  SizedBox(width: 15),
                  Text('Excluir conta',style: TextStyle(color: Colors.black, fontSize: 26)),
                ],
              )
            ),
          ),
        ],
      ),
    );
  }
}

class PerfilMotorista extends StatefulWidget {
  const PerfilMotorista({Key? key}) : super(key: key);

  @override
  State<PerfilMotorista> createState() => _PerfilMotoristaState();
}

class _PerfilMotoristaState extends State<PerfilMotorista> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
    child: Scaffold(
      body: Center(
        child: FutureBuilder<List<Motorista>>(
            future:  downloadJSON(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Motorista> motorista = snapshot.requireData.toList();
                return CustomListView(motorista);
              } else if (snapshot.hasError) {
                print(snapshot.error.toString());
                return Text('${snapshot.error}');
              }
              return Container();
            }, 
          ),
        ),
      ),
    );
  }
}

class AlterarUsuario extends StatefulWidget {

  final Motorista value;
  AlterarUsuario({required this.value});

  @override
  State<AlterarUsuario> createState() => _AlterarUsuarioState();
}

class _AlterarUsuarioState extends State<AlterarUsuario> {
  final _formKey = GlobalKey<FormState>();
  
  validar() async{
    if(!_formKey.currentState!.validate()){
      ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Por favor, Insira as informações corretamente!',textAlign:TextAlign.center, style: TextStyle(fontSize: 22, color: Colors.white)),
        backgroundColor:Color.fromARGB(255, 245, 82, 82),duration: Duration(milliseconds: 2500),
      ));
      return;    
    } else{ 
      _formKey.currentState!.save();
      if(email != emailC.text){
        mesmoEmail = false;
      }
      await update();
      if (emailRepetido == "") {
        setState(() {
        limparCampos();
        });
        indexglobal = 2;
        Navigator.pushReplacementNamed(context, '/screens/homeMotorista/home_motorista_page');   
      } else{
        emailRepetido = "";
        return;
      }
    }
  }  
    
  String? email = "";
  bool? mesmoEmail = true;
  String? emailRepetido = "";
  Future update() async {
    // Aqui precisa mudar o endereço:
    var url = Uri.parse('http://'+localhost+'/api_tcc/Perfil/alterarperfil.php');
    var resposta = await http.post(url, 
    headers: {'Charset': 'utf-8'},
    body:   
    {
      'Nome': nomeC.text.toString(),
      'Email': emailC.text.toString(),
      'Senha': senhaC.text.toString(),
      'Telefone': telefoneC.text.toString(),
      'Cpf': cpfC.text.toString(),
      'Estado': estadoC.text.toString().toUpperCase(),
      'Cidade': cidadeC.text.toString(),
      'Bairro': bairroC.text.toString(),
      'Endereco': enderecoC.text.toString(),
      'Cep': cepC.text.toString(),
      'IDUsuario': widget.value.IDUsuario.toString(),
      'MesmoEmail': mesmoEmail.toString(),
    });
    var data = json.decode(resposta.body);
    if (resposta.statusCode == 200 && data['Retorno'] == "Success") {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Sucesso ao alterar perfil!',textAlign:TextAlign.center, style: TextStyle(fontSize: 22, color: Colors.white)),
        backgroundColor:Colors.greenAccent,duration: Duration(milliseconds: 4000),
      )); 
    }else if (resposta.statusCode == 200 && data['Retorno'] == "Ja existe esse email") {
      emailRepetido = data['Retorno'].toString();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Já existe uma conta registrada nesse e-mail',textAlign:TextAlign.center, style: TextStyle(fontSize: 22, color: Colors.white)),
        backgroundColor:Color.fromARGB(255, 245, 82, 82),duration: Duration(milliseconds: 2500),
      )); 
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Erro ao Alterar. \nTente novamente!',textAlign:TextAlign.center, style: TextStyle(fontSize: 22, color: Colors.white)),
        backgroundColor:Color.fromARGB(255, 245, 82, 82),duration: Duration(milliseconds: 2500),
      ));
    }
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
    email = "";
    mesmoEmail = true;
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
    email = emailC.text;
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
                      indexglobal = 2;
                      Navigator.pushNamedAndRemoveUntil(context, '/screens/homeMotorista/home_motorista_page',(route) => false);
                    }, 
                    icon: Icon(Icons.arrow_back),
                  )
              ]),
              Text("Alterar Dados",style: TextStyle(fontSize: 42,)),
              SizedBox(height: 40),
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
                child: TextButton(child: Text('Alterar Infomações', style: TextStyle(color: Colors.black, fontSize: 25)),onPressed: validar)),
              SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }
}
// Veículos do motorista:
class VeiculosPage extends StatefulWidget {
  const VeiculosPage({Key? key}) : super(key: key);

  @override
  State<VeiculosPage> createState() => _VeiculosPageState();
}
class _VeiculosPageState extends State<VeiculosPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text("Meus Veículos"), centerTitle: true, actions: <Widget> [
          IconButton(
            onPressed: (){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CadastroVeiculoPage()));
            }, 
            icon: Icon(Icons.directions_car_filled_rounded, size: 26)
          )
        ]),
        body: Center(
          child: FutureBuilder<List<Veiculo>>(
            future:  downloadJSONVeiculo(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Veiculo> veiculo = snapshot.requireData.toList();
                if(veiculo.toString() == "[]"){
                  return Text("Você não possui nenhum Veículo!", style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold));
                }
                return CustomListViewVeiculo(veiculo);
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

String? IDVeiculo;
Future excluirVeiculo() async {
  // Aqui precisa mudar o endereço:
  var url = Uri.parse('http://'+localhost+'/api_tcc/Veiculo/excluirveiculo.php');
  var resposta = await http.post(url, 
  headers: {'Charset': 'utf-8'},
  body:   
  {
    'IDVeiculo': IDVeiculo,
  });
  if (resposta.statusCode != 200) {
    throw Exception('Erro ao excluir veiculo!');
  }
}

Future<List<Veiculo>> downloadJSONVeiculo() async {
  // Aqui precisa mudar o endereço:
  var url = Uri.parse('http://'+localhost+'/api_tcc/Veiculo/meusveiculos.php');
  var resposta = await http.post(url, 
  headers: {'Charset': 'utf-8'},
  body:   
  {
    'IDUsuario': idUsuario.toString(),
  });
  if (resposta.statusCode == 200) {
    List veiculo = json.decode(resposta.body);
    return veiculo.map((veiculo) => Veiculo.fromJson(veiculo)).toList();
  } else {
    throw Exception('Erro ao recuperar dados!!!');
  }
}

class CustomListViewVeiculo extends StatefulWidget {
  final List<Veiculo> veiculo;
  CustomListViewVeiculo(this.veiculo);

  @override
  State<CustomListViewVeiculo> createState() => _CustomListViewVeiculoState();
}
class _CustomListViewVeiculoState extends State<CustomListViewVeiculo> {
  Widget build(context) {
    return RefreshIndicator(
      onRefresh: () async{ 
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => VeiculosPage()));
      },
      child: ListView.builder(
        itemCount: widget.veiculo.length,
        itemBuilder: (context, int currentIndex) {
          return createViewItemVeiculo(widget.veiculo[currentIndex], context);
        },
      ),
    );
  }
  String? idVeiculoFoto;
  String? fotoAntigaVeiculo;
  Future trocarFotoVeiculo() async {
    // Aqui precisa mudar o endereço:
    var url = Uri.parse('http://'+localhost+'/api_tcc/Veiculo/trocarfoto.php');
    var resposta = await http.post(
        url,
        body: {
          'DataImagem': imagedataVeiculo,
          'NomeImagem': imagenameVeiculo,
          'IDVeiculo': idVeiculoFoto.toString(), 
          'FotoAntiga': fotoAntigaVeiculo.toString(),
        },
    );
    var data = json.decode(resposta.body);
    if (resposta.statusCode == 200 && data['Retorno'] == "Success") {
      imagepathVeiculo = null;
      imagedataVeiculo = null;
      imagenameVeiculo = null;
      imagemveiculo = "";
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => VeiculosPage()));
    }else{
      print("Deu erro");
    }
  }

  File? imagepathVeiculo;
  String? imagenameVeiculo;
  String? imagedataVeiculo;
  String? imagemveiculo;
  ImagePicker imagePickerVeiculo = ImagePicker();
  Future<void> pickImageVeiculo(ImageSource source) async{
    try {
      var getimage = await imagePickerVeiculo.pickImage(source: source);
      setState(() {
        imagepathVeiculo = File(getimage!.path);
        imagenameVeiculo = getimage.path.split('/').last;
        imagedataVeiculo = base64Encode(imagepathVeiculo!.readAsBytesSync());
        imagemveiculo = "";
        trocarVeiculo();
        
      });
    } on PlatformException catch (e) {
      print("falha ao pegar imagem: $e");
    }
  }

  trocarVeiculo () async{
    await trocarFotoVeiculo();
  }

  imagemVeiculo(veiculo){
    return veiculo.Fotodata.toString() == "../imageupload_veiculo/Fotonãoexistente"  
      ? Center(child: Image.asset("assets/caminhao.jpg",fit: BoxFit.fill,width: 180,height: 180))
      :Center(
        child: Image.network(
        veiculo.Foto,
        width: 180,
        height: 180,
        fit: BoxFit.fill,
        ),
      );
  }
  
  Widget createViewItemVeiculo(Veiculo veiculo, BuildContext context) {
    downloadJSONVeiculo();
    imagemVeiculo(veiculo);
    return Card(
      color: Colors.white,
      child: Container(
        height: 520,
        decoration: BoxDecoration(border: Border.all(color: Colors.black54)),
        padding: EdgeInsets.all(3),
        margin: EdgeInsets.all(5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            InkWell(
              onTap: () {
                idVeiculoFoto = veiculo.ID.toString();
                fotoAntigaVeiculo = veiculo.Fotodata.toString();
                showModalBottomSheet(context: context,
                builder: (BuildContext context) {
                  return SafeArea(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading:  Icon(Icons.camera_alt_outlined, size:28, color: Colors.black),
                          title:  Text('Camera', style: TextStyle(fontSize: 20)),
                          onTap: ()=>{
                            pickImageVeiculo(ImageSource.camera),
                            Navigator.pop(context)
                          }
                        ),
                        ListTile(
                          leading:  Icon(Icons.image, size:28, color: Colors.black),
                          title:  Text('Galeria', style: TextStyle(fontSize: 20)),
                          onTap: ()=>{
                            pickImageVeiculo(ImageSource.gallery),
                            Navigator.pop(context)
                          }
                        ),
                        ListTile(
                          leading:  Icon(Icons.close, size:28, color: Colors.black),
                          title:  Text('Remover foto', style: TextStyle(fontSize: 20)),
                          onTap: () {
                            setState(() {
                              
                              if(imagedataVeiculo == null && imagenameVeiculo == null){
                                imagedataVeiculo = "não possui foto";
                                imagenameVeiculo = "Fotonãoexistente";
                              }
                              imagemveiculo = "Fotonãoexistente";
                              trocarFotoVeiculo();
                              imagemVeiculo(veiculo);
                            });
                            Navigator.pop(context);
                          }
                        ),
                      ],
                    ),
                  );
                }
                );
              },
              child: imagemVeiculo(veiculo)
            ),
            Center(child: Text("Descrição do Veículo:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
            SizedBox(height: 6),
            Text(veiculo.Descricao, style: TextStyle(fontSize: 17)),
            Divider(color: Colors.black, thickness: 1),
            Center(child: Text("Detalhes do Veículo:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
            SizedBox(height: 9),
            Row(children: [
              Text("Placa:", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
              SizedBox(width: 6),
              Text(veiculo.Placa, style: TextStyle(fontSize: 17)),
            ]),
            SizedBox(height: 9),
            Row(children: [
              Text("Modelo:", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
              SizedBox(width: 6),
              Text(veiculo.Modelo, style: TextStyle(fontSize: 17)),
            ]),
            SizedBox(height: 9),
            Row(children: [
              Text("Ano:", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
              SizedBox(width: 6),
              Text(veiculo.Ano, style: TextStyle(fontSize: 17)),
            ]),
            SizedBox(height: 9),
            Row(children: [
              Text("Possui Seguro:", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
              SizedBox(width: 6),
              Text(veiculo.PossuiSeguro == "true" ? "Sim" : "Não", style: TextStyle(fontSize: 17)),
            ]),
            SizedBox(height: 9),
            Row(children: [
              Text("Precisa de Refrigeração:", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
              SizedBox(width: 6),
              Text(veiculo.PossuiRefrigeracao == "true" ? "Sim" : "Não", style: TextStyle(fontSize: 17)),
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
                  child: Text("Alterar Veículo",style: TextStyle(fontSize: 20)),
                  onPressed: (){
                    descricaoVeiculoC.text = veiculo.Descricao;
                    placaC.text = veiculo.Placa;
                    modeloC.text = veiculo.Modelo;
                    anoC.text = veiculo.Ano;
                    if(veiculo.PossuiSeguro == "true"){
                      possuiSeguro = true;
                    }else{
                      possuiSeguro = false;  
                    }
                    if(veiculo.PossuiRefrigeracao == "true"){
                      possuiRefrigeracao = true;
                    }else{
                      possuiRefrigeracao = false;  
                    }
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AlterarVeiculo(value: veiculo)));
                  }
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.redAccent,
                    textStyle: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold)
                  ),
                  child: Text("Excluir Veículo",style: TextStyle(fontSize: 20)),
                  onPressed: () async{
                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: Text('Excluir Veículo'),
                        content: Text('Você tem certeza que deseja excluir esse veículo? \n\n(essa ação é permanente)'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('Cancelar'),
                          ),
                          TextButton(
                            onPressed: () async {
                              IDVeiculo = veiculo.ID.toString();
                              await excluirVeiculo();
                              Navigator.of(context).pushNamedAndRemoveUntil('/screens/homeMotorista/perfil_page', ModalRoute.withName('/screens/homeMotorista/home_motorista_page'));
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('Veículo Excluído com Sucesso!',textAlign:TextAlign.center, style: TextStyle(fontSize: 22, color: Colors.white)),
                                backgroundColor:Colors.greenAccent,duration: Duration(milliseconds: 2000),
                              )); 
                            },
                            child: Text('Sim'),
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
class AlterarVeiculo extends StatefulWidget {
  final Veiculo value;
  AlterarVeiculo({required this.value});
  @override
  State<AlterarVeiculo> createState() => _AlterarVeiculoState();
}

class _AlterarVeiculoState extends State<AlterarVeiculo> {
  
  final _formKey = GlobalKey<FormState>();
  String? PlacaRepetida = "";
  String? VeiculoID;
  String? placa = "";
  bool? mesmaPlaca = true;
  Future alterarVeiculo() async{
    // Aqui precisa mudar o endereço:
    var url = Uri.parse('http://'+localhost+'/api_tcc/Veiculo/alterarveiculo.php');
    var resposta = await http.post(
        url,
        body: {
          'IDVeiculo': VeiculoID.toString(),
          'Descricao': descricaoVeiculoC.text,
          'Placa': placaC.text,
          'Modelo': modeloC.text,
          'Ano': anoC.text,
          'PossuiSeguro': possuiSeguro.toString(),
          'PossuiRefrigeracao': possuiRefrigeracao.toString(),
          'mesmaPlaca': mesmaPlaca.toString(),
        },
    );
    var data = json.decode(resposta.body);
    if (resposta.statusCode == 200 && data['Retorno'] == "Success") {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Sucesso ao alterar Veículo!',textAlign:TextAlign.center, style: TextStyle(fontSize: 22, color: Colors.white)),
        backgroundColor:Colors.greenAccent,duration: Duration(milliseconds: 4000),
      )); 
    } else if (resposta.statusCode == 200 && data['Retorno'] == "Placa Repetida") {
      PlacaRepetida = data['Retorno'].toString();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Essa placa já foi registrada!',textAlign:TextAlign.center, style: TextStyle(fontSize: 22, color: Colors.white)),
        backgroundColor:Color.fromARGB(255, 245, 82, 82),duration: Duration(milliseconds: 2500),
      )); 
    } else{
      PlacaRepetida = data['Retorno'].toString();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Erro ao Alterar. \nTente novamente!',textAlign:TextAlign.center, style: TextStyle(fontSize: 22, color: Colors.white)),
        backgroundColor:Color.fromARGB(255, 245, 82, 82),duration: Duration(milliseconds: 2500),
      ));
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
      placa = "";
      PlacaRepetida = "";
      mesmaPlaca = true;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    placa = placaC.text;
    VeiculoID = widget.value.ID.toString();
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
                "Alterar Veículo", textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 42, 
                ),
              ),
              SizedBox(height: 35),
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
                child: TextButton(child: Text('Alterar Veículo', style: TextStyle(color: Colors.black, fontSize: 25)),onPressed: () async{
                    if (!_formKey.currentState!.validate()) {
                      return;
                    } else {
                      if(placa != placaC.text){
                        mesmaPlaca = false;
                      }
                      await alterarVeiculo();
                      if (PlacaRepetida == "") {
                        setState(() {
                          limparCampos();
                        });
                        Navigator.pushReplacementNamed(context, '/screens/homeMotorista/perfil_page');   
                      } else{
                        PlacaRepetida = "";
                        return;
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

Future<List<PropostasFinalizadas>> downloadJSONPropostasFinalizadas() async {
  var url = Uri.parse('http://'+localhost+'/api_tcc/Perfil/propostasfinalizadas.php');
  var resposta = await http.post(
      url,
      body: {
        'IDUsuario': idUsuario.toString()
      },
  );
  if (resposta.statusCode == 200) {
    List propostasFinalizadas = json.decode(resposta.body);
    return propostasFinalizadas.map((propostasFinalizadas) => PropostasFinalizadas.fromJson(propostasFinalizadas)).toList();
  } else {
    throw Exception('Erro ao recuperar dados!!!');
  }
}

class CustomListViewPropostasFinalizadas extends StatefulWidget {
  final List<PropostasFinalizadas> propostasFinalizadas;
  CustomListViewPropostasFinalizadas(this.propostasFinalizadas);

  @override
  State<CustomListViewPropostasFinalizadas> createState() => _CustomListViewPropostasFinalizadasState();
}
class _CustomListViewPropostasFinalizadasState extends State<CustomListViewPropostasFinalizadas> {

  Widget build(context) {
    return ListView.builder(
      itemCount: widget.propostasFinalizadas.length,
      itemBuilder: (context, int currentIndex) {
        return createViewItem(widget.propostasFinalizadas[currentIndex], context);
      },
    );
  }

  imagemCliente(propostasFinalizadas){
    return propostasFinalizadas.Fotodata.toString() == "../imageupload/Fotonãoexistente"
      ? ClipOval(child: Image.asset("assets/person_add.png",fit: BoxFit.fill,width: 120,height: 120))
      :ClipOval(
        child: Image.network(
        propostasFinalizadas.Foto,
        width: 160,
        height: 160,
        fit: BoxFit.fill,
        ),
      );
  }

  Widget createViewItem(PropostasFinalizadas propostasFinalizadas, BuildContext context) {
    return Card(
      color: Colors.white,
      child: Container(
        height: 1025,
        decoration: BoxDecoration(border: Border.all(color: Colors.black54)),
        padding: EdgeInsets.all(3),
        margin: EdgeInsets.all(5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Center(child: Text("Descrição:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
            SizedBox(height: 6),
            Text(propostasFinalizadas.Descricao, style: TextStyle(fontSize: 17)),
            Divider(color: Colors.black, thickness: 1),
            Center(child: Text("Detalhes da Proposta:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
            SizedBox(height: 9),
            Row(children: [
              Text("Valor: ", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(width: 6),
              Text('R\$ ${propostasFinalizadas.Valor}', style: TextStyle(fontSize: 18)),
            ]),
            SizedBox(height: 9),
            Row(children: [
              Text("Tipo do Produto:", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
              SizedBox(width: 6),
              Text(propostasFinalizadas.TipoProduto, style: TextStyle(fontSize: 16.5)),
            ]),
            SizedBox(height: 9),
            Row(children: [
              Text("Tipo da Carga:", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
              SizedBox(width: 6),
              Text(propostasFinalizadas.TipoCarga, style: TextStyle(fontSize: 16.5)),
            ]),
            SizedBox(height: 9),
            Row(children: [
              Text("Tipo do Veículo:", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
              SizedBox(width: 6),
              Text(propostasFinalizadas.TipoVeiculo, style: TextStyle(fontSize: 16.5)),
            ]),
            SizedBox(height: 9),
            Row(children: [
              Text("Quantidade:", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
              SizedBox(width: 6),
              Text(propostasFinalizadas.Quantidade, style: TextStyle(fontSize: 17)),
            ]),
            SizedBox(height: 9),
            Row(children: [
              Text("Massa:", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
              SizedBox(width: 6),
              Text(propostasFinalizadas.Massa, style: TextStyle(fontSize: 17)),
              SizedBox(width: 2),
              Text(propostasFinalizadas.Unidade, style: TextStyle(fontSize: 17)),
            ]),
            Divider(color: Colors.black, thickness: 1),
            Row(children: [
              Text("Data de Retirada:", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
              SizedBox(width: 6),
              Text(propostasFinalizadas.DataRetirada, style: TextStyle(fontSize: 17)),
            ]),
            SizedBox(height: 9),
            Row(children: [
              Text("Data de Entrega:", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
              SizedBox(width: 6),
              Text(propostasFinalizadas.DataEntrega, style: TextStyle(fontSize: 17)),
            ]),
            SizedBox(height: 9),
            Text("Origem:", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            SizedBox(height: 6),
            Text(propostasFinalizadas.Origem, style: TextStyle(fontSize: 17)),
            SizedBox(height: 9),
            Text("Destino:", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            SizedBox(height: 6),
            Text(propostasFinalizadas.Destino, style: TextStyle(fontSize: 17)),
            SizedBox(height: 9),
            Row(children: [
              Text("Possui Seguro:", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
              SizedBox(width: 6),
              Text(propostasFinalizadas.possuiSeguro == "true" ? "Sim" : "Não", style: TextStyle(fontSize: 17)),
            ]),
            SizedBox(height: 9),
            Row(children: [
              Text("Precisa de Refrigeração:", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
              SizedBox(width: 6),
              Text(propostasFinalizadas.PrecisaSerRefrigerado == "true" ? "Sim" : "Não", style: TextStyle(fontSize: 17)),
            ]),
            Divider(color: Colors.black, thickness: 1),
            SizedBox(height: 4),
            Center(child: Text("Cliente:", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold))),
            SizedBox(height: 20),
            Center(child: imagemCliente(propostasFinalizadas)),
            SizedBox(height: 15),
            Row(children: [
              Text("Nome: ", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
              SizedBox(width: 6),
              Text(propostasFinalizadas.Nome, style: TextStyle(fontSize: 17)),
            ]),
            SizedBox(height: 9),
            Row(children: [
              Text("Telefone: ", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
              SizedBox(width: 6),
              Text(propostasFinalizadas.Telefone, style: TextStyle(fontSize: 17)),
            ]),
            SizedBox(height: 9),
            Row(children: [
              Text("E-mail: ", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(width: 6),
              Text(propostasFinalizadas.Email, style: TextStyle(fontSize: 17)),
            ]),
            SizedBox(height: 2),
            Divider(color: Colors.black, thickness: 1),
            SizedBox(height: 8),
            Center(child: Text("Período da Proposta:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
            SizedBox(height: 9),
            Row(children: [
              Text("Data Aceita:", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
              SizedBox(width: 6),
              Text(propostasFinalizadas.DataAceita, style: TextStyle(fontSize: 17)),
            ]),
            SizedBox(height: 9),
            Row(children: [
              Text("Data Final:", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
              SizedBox(width: 6),
              Text(propostasFinalizadas.DataFinal, style: TextStyle(fontSize: 17)),
            ]),

          ],
        ),
      ),
    );
  }
}

class PropostasFinalizadasPage extends StatefulWidget {
  const PropostasFinalizadasPage({Key? key}) : super(key: key);
  @override
  State<PropostasFinalizadasPage> createState() => _PropostasFinalizadasPageState();
}

class _PropostasFinalizadasPageState extends State<PropostasFinalizadasPage> {
  @override
  Widget build(BuildContext context) {
     return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text("Propostas Finalizadas"), centerTitle: true, ),
        body: Center(
          child: FutureBuilder<List<PropostasFinalizadas>>(
            future:  downloadJSONPropostasFinalizadas(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<PropostasFinalizadas> propostasFinalizadas= snapshot.requireData.toList();
                if(propostasFinalizadas.toString() == "[]"){
                  return Text("Você não concluiu nenhuma Proposta!", style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold), textAlign: TextAlign.center,);
                }
                return CustomListViewPropostasFinalizadas(propostasFinalizadas);
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