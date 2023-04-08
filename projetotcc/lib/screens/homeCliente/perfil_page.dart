// ignore_for_file: prefer_const_constructors, sort_child_properties_last, use_build_context_synchronously, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:projetotcc/model/perfil_cliente.dart';
import 'package:projetotcc/model/propostas_finalizadas.dart';
import 'package:projetotcc/model/url.dart';
import 'package:projetotcc/screens/homeCliente/home_cliente_page.dart';
import 'dart:convert';
import 'package:projetotcc/screens/login/login_page.dart';
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

Future<List<Cliente>> downloadJSON() async {
  // Aqui precisa mudar o endereço:
  var url = Uri.parse('http://'+localhost+'/api_tcc/Perfil/perfil.php');
  var resposta = await http.post(url, 
  headers: {'Charset': 'utf-8'},
  body:   
  {
    'IDUsuario': idUsuario.toString(),
  });
  if (resposta.statusCode == 200) {
    List cliente = json.decode(resposta.body);
    return cliente.map((cliente) => Cliente.fromJson(cliente)).toList();
  } else {
    throw Exception('Erro ao recuperar dados!!!');
  }
}

class CustomListView extends StatefulWidget {
  final List<Cliente> cliente;
  CustomListView(this.cliente);

  @override
  State<CustomListView> createState() => _CustomListViewState();
}
class _CustomListViewState extends State<CustomListView> {
  Widget build(context) {
    return ListView.builder(
        itemCount: widget.cliente.length,
        itemBuilder: (context, int currentIndex) {
          return createViewItem(widget.cliente[currentIndex], context);    
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
      indexglobal = 3;
      Navigator.pushReplacementNamed(context, '/screens/homeCliente/home_cliente_page');
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

  imagem(cliente){
    return cliente.Fotodata.toString() == "../imageupload/Fotonãoexistente" || imagemperfil == "Fotonãoexistente" 
      ? ClipOval(child: Image.asset("assets/person_add.png",fit: BoxFit.fill,width: 140,height: 140))
      :ClipOval(
        child: Image.network(
        cliente.Foto,
        width: 140,
        height: 140,
        fit: BoxFit.fill,
        ),
      );
  }
  
  Widget createViewItem(Cliente cliente, BuildContext context) {
    downloadJSON();
    fotoAntiga = cliente.Fotodata;
    imagem(cliente);
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
                            imagem(cliente);
                          });
                          Navigator.pop(context);
                        }
                      ),
                    ],
                  ),
                );
              }
            ),
            child: imagem(cliente)
          ),
          SizedBox(height: 20),
          Text(cliente.Nome, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Text(cliente.Email, style: TextStyle(fontSize: 17)),
          SizedBox(height: 35),
          InkWell(
            onTap: (){
              nomeC.text = cliente.Nome;
              emailC.text = cliente.Email;
              senhaC.text = cliente.Senha;
              telefoneC.text = cliente.Telefone;
              cpfC.text = cliente.CPF;
              estadoC.text = cliente.Estado;
              cidadeC.text = cliente.Cidade;
              bairroC.text = cliente.Bairro;
              enderecoC.text = cliente.Endereco;
              cepC.text = cliente.CEP;
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AlterarUsuario(value: cliente)));
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
          SizedBox(height: 20),
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
                  Text('Propostas Fechadas', style: TextStyle(color: Colors.black, fontSize: 26)),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_forward_ios_rounded, size: 26),
                ],
              )
            ),
          ),
          SizedBox(height: 20),
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
          SizedBox(height: 50),
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

class PerfilCliente extends StatefulWidget {
  const PerfilCliente({Key? key}) : super(key: key);

  @override
  State<PerfilCliente> createState() => _PerfilClienteState();
}

class _PerfilClienteState extends State<PerfilCliente> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
    child: Scaffold(
        body: Center(
          child: FutureBuilder<List<Cliente>>(
                future:  downloadJSON(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<Cliente> cliente = snapshot.requireData.toList();
                    return CustomListView(cliente);
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

  final Cliente value;
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
        indexglobal = 3;
        Navigator.pushReplacementNamed(context, '/screens/homeCliente/home_cliente_page');   
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
        content: Text('Erro ao Cadastrar. \nTente novamente!',textAlign:TextAlign.center, style: TextStyle(fontSize: 22, color: Colors.white)),
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
                      indexglobal = 3;
                      Navigator.pushNamedAndRemoveUntil(context, '/screens/homeCliente/home_cliente_page',(route) => false);
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

  imagemMotorista(propostasFinalizadas){
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
            Center(child: Text("Motorista:", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold))),
            SizedBox(height: 20),
            Center(child: imagemMotorista(propostasFinalizadas)),
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