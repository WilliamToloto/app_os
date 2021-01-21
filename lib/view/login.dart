import 'package:app_novo/view/os.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
        centerTitle: true,
        actions: [],
      ),
      body: Form(
          child: ListView(
        padding: EdgeInsets.all(10.0),
        children: [
          TextFormField(
            //controller: _usuarioController,
            decoration: InputDecoration(hintText: "Usuário"),
            keyboardType: TextInputType.emailAddress,
            // ignore: missing_return
            validator: (text) {
              if (text.isEmpty) return "usuário inválido";
            },
          ),
          SizedBox(
            height: 20.0,
          ),
          TextFormField(
            //controller: _senhaController,
            decoration: InputDecoration(hintText: "Senha"),
            obscureText: true,
            // ignore: missing_return
            validator: (text) {
              if (text.isEmpty || text.length < 6) return "senha inválida";
            },
          ),
          SizedBox(
            height: 40.0,
          ),
          SizedBox(
              height: 48.0,
              child: ElevatedButton(
                child: Text(
                  "Entrar",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  ),
                ),
                onPressed: () => Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => OS())),
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  onPrimary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32.0),
                  ),
                ),
              ))
        ],
      )),
    );
  }
}
