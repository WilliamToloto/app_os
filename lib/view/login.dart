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
  final _operadorController = TextEditingController();
  final _senhaController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  //Declaração da variável do checkbox;
  bool checkedValue = false;

  //Desing e comportamento dos elementos da tela
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
        centerTitle: true,
      ),
      body: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.all(20.0),
            children: [
              TextFormField(
                inputFormatters: [UpperCaseTextFormatter()],
                autocorrect: false,
                enableSuggestions: false,
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
                obscureText: (!checkedValue),
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
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        BotToast.showLoading(
                          duration: Duration(seconds: 2),
                          clickClose: false,
                        );
                        Response response;
                        Dio dio = new Dio();
                        String url = 'http://192.168.15.5:8090/api/Login1';
                        try {
                          await dio.get(url);
                        } on DioError catch (e) {
                          if (e.response != null) {
                            print(e.response.data);
                          } else {
                            BotToast.showText(
                                text: "FALHA NA CONEXÃO",
                                duration: Duration(milliseconds: 2000),
                                clickClose: true,
                                backgroundColor: Colors.black26);
                          }
                        }
                        //String url = 'http://192.168.1.66:8090/api/Login1';
                        //'http://192.168.15.2:8090/api/Login1';
                        // String url = 'https://webhook.site/ede21526-bec6-4089-b18d-cd4941184db9';
                        // String url = 'http://localhost:8090/api/Login1';
                        response = await dio.post(url, data: {
                          "operador": _operadorController.text,
                          "senha": _senhaController.text
                        });

                        print(response.data.toString());
                        var resposta = response.data.toString();

                        if (resposta == "not_found") {
                          //Salva o usuário logado
                          BotToast.showText(
                              text: "DADOS INCORRETOS",
                              backButtonBehavior: BackButtonBehavior.close,
                              clickClose: true,
                              backgroundColor: Colors.black26);
                        } else {
                          print(response.data['Nivel']);
                          print(response.data['removeapp']);
                          //  print(response.data['error']['originalError']
                          //      ['info']['message']);
                          final prefs = await SharedPreferences.getInstance();
                          final prefs1 = await SharedPreferences.getInstance();
                          //final prefs2 = await SharedPreferences.getInstance();
                          final key = 'operador';
                          final value = _operadorController.text;
                          final key1 = 'nivel';
                          final value1 = response.data['Nivel'];
                          final key2 = 'removeapp';
                          final value2 = response.data['removeapp'].toString();
                          // final key3 = 'usaapp';
                          // final value3 = response.data['usaapp'].toString();

                          prefs.setString(key, value);
                          prefs1.setString(key1, value1);
                          prefs1.setString(key2, value2);
                          //prefs2.setString(key3, value3);
                          print('saved $value');

                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (context) => OS()));
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
                  )),
              SizedBox(
                height: 40.0,
              ),
              SizedBox(
                height: 30.0,
                child: CheckboxListTile(
                  title: Text("Mostrar Senha"),
                  value: checkedValue,
                  onChanged: (newValue) {
                    setState(() {
                      checkedValue = newValue;
                    });
                  },
                ),
              ),
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
