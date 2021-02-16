import 'package:app_novo/view/telaos.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  final _operadorController = TextEditingController();
  final _senhaController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
        centerTitle: true,
        actions: [],
      ),
      body: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.all(10.0),
            children: [
              TextFormField(
                inputFormatters: [UpperCaseTextFormatter()],
                autocorrect: false,
                controller: _operadorController,
                decoration: InputDecoration(hintText: "Usuário"),
                // keyboardType: TextInputType.emailAddress,
                // ignore: missing_return
                validator: (text) {
                  if (text.isEmpty) return "usuário inválido";
                },
              ),
              SizedBox(
                height: 20.0,
              ),
              TextFormField(
                inputFormatters: [UpperCaseTextFormatter()],
                controller: _senhaController,
                decoration: InputDecoration(hintText: "Senha"),
                obscureText: true,
                // ignore: missing_return
                validator: (text) {
                  if (text.isEmpty || text.length < 4) return "senha inválida";
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
                    //
                    //
                    // onPressed: () => Navigator.of(context).pushReplacement(
                    //     MaterialPageRoute(builder: (context) => OS())),
                    //
                    //
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        BotToast.showLoading(
                          duration: Duration(seconds: 1),
                        );
                        Response response;
                        Dio dio = new Dio();

                        String url = 'http://192.168.15.2:8090/api/Login1';
                        //'http://192.168.15.2:8090/api/Login1';
                        // String url = 'https://webhook.site/ede21526-bec6-4089-b18d-cd4941184db9';
                        // String url = 'http://localhost:8090/api/Login1';
                        response = await dio.post(url, data: {
                          "operador": _operadorController.text,
                          "senha": _senhaController.text
                        });

                        print(response.data.toString());
                        var resposta = response.data.toString();
                        print(resposta);

                        if (resposta == "ok") {
                          //Salva o usuário logado
                          final prefs = await SharedPreferences.getInstance();
                          final key = 'operador';
                          final value = _operadorController.text;
                          prefs.setString(key, value);
                          print('saved $value');
                          ////////FIM
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (context) => OS()));
                        } else {
                          BotToast.showText(
                              text: "DADOS INCORRETOS",
                              backButtonBehavior: BackButtonBehavior.close,
                              clickClose: true,
                              backgroundColor: Colors.black26);
                        }
                      }
                    },
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

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text?.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
