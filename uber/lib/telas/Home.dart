import 'package:flutter/material.dart';
import 'package:uber/model/Usuario.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  TextEditingController _controllerEmail = TextEditingController(text: "mateus@passageiro.com");
  TextEditingController _controllerSenha = TextEditingController(text: "123456");
  String _messagemErro = "";
  bool _carregando = false;

  _validarCampos() {
    //Recuperar dados dos campos
    String email = _controllerEmail.text;
    String senha = _controllerSenha.text;

    //Validar campos
    if (email.isNotEmpty && email.contains('@')) {
      if (senha.isNotEmpty && senha.length > 5) {
        Usuario usuario = Usuario();
        usuario.email = email;
        usuario.senha = senha;

        _logarUsuario(usuario);

      } else {
        setState(() {
          _messagemErro = "Preencha a senha! digite mais de 5 caracteres";
        });
      }
    }
  }

  _logarUsuario(Usuario usuario){

    setState(() {
      _carregando = true;
    });

    FirebaseAuth auth =FirebaseAuth.instance;

    auth.signInWithEmailAndPassword(
        email: usuario.email,
        password: usuario.senha
    ).then((firebaseUser){

      _redirecionamentoPainelProTipoUsuario(firebaseUser.user.uid);

    }).catchError((error){
      _messagemErro = "Erro ao autenticar usuário, verifique e-mail e senha e tente novamente!";
    });
  }

  _redirecionamentoPainelProTipoUsuario(String idUsuario) async{

    Firestore db = Firestore.instance;

    DocumentSnapshot snapshot = await db.collection("usuarios")
      .document(idUsuario)
      .get();

    Map<String, dynamic> dados = snapshot.data;
    String tipoUsuario = dados["tipoUsuario"];

    setState(() {
      _carregando = false;
    });

    switch(tipoUsuario){
      case "motorista" :
        Navigator.pushReplacementNamed(context, "/motorista");
        break;
      case "passageiro" :
        Navigator.pushReplacementNamed(context, "/passageiro");
        break;
    }
  }

  _verificaUsuarioLogado() async{
    FirebaseAuth auth = FirebaseAuth.instance;

    FirebaseUser usuarioLogado = await auth.currentUser();
    if(usuarioLogado!=null){
      String idUsuario = usuarioLogado.uid;
      _redirecionamentoPainelProTipoUsuario(idUsuario);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _verificaUsuarioLogado();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("imagens/fundo.png"),
            fit: BoxFit.cover
          )
        ),
        padding: EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 32),
                  child: Image.asset(
                      "imagens/logo.png",
                    width: 200,
                    height: 150,
                  ),
                ),
                TextField(
                  controller: _controllerEmail,
                  autofocus: false,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                    hintText: "e-mail",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6)
                    )
                  ),
                ),
                TextField(
                  controller: _controllerSenha,
                  obscureText: true,
                  keyboardType: TextInputType.visiblePassword,
                  style: TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      hintText: "senha",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6)
                      )
                  ),
                ),
                _carregando
                  ? Center(child: CircularProgressIndicator(backgroundColor: Colors.white,),)
                  : Container(),
                Padding(
                  padding: EdgeInsets.only(top: 16, bottom: 20),
                  child: RaisedButton(
                      child: Text(
                        "Entrar",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      color: Color(0xff1ebbd8),
                      padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      onPressed: (){
                        _validarCampos();
                      },
                  ),
                ),
                Center(
                  child: GestureDetector(
                    child: Text(
                      "Não tem conta? cadastre-se!",
                      style: TextStyle(color: Colors.white, decoration: TextDecoration.underline),
                    ),
                    onTap: (){
                      Navigator.pushNamed(context, "/cadastro");
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Center(
                    child: Text(
                        _messagemErro,
                      style: TextStyle(color: Colors.red, fontSize: 20)
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
