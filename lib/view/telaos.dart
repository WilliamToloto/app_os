import 'dart:convert';

import 'package:app_novo/model/produtoOs.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OS extends StatefulWidget {
  @override
  _OSState createState() => _OSState();
}

class _OSState extends State<OS> {
  static _read() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'operador';
    final value = prefs.getString(key);
    print('saved tester $value');
    String operadorLogado = value;
    return operadorLogado;
  }

  List produtosList = [];

  @override
  final _numeroOsController = TextEditingController();
  void initState() {
    super.initState();
    _read();

    //WidgetsBinding.instance.addPostFrameCallback((_) => _read());

    // final prefs = await SharedPreferences.getInstance();
    // final key = 'usuario';
    // final value = prefs.getString(key);
    // print('saved $value');
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("OS  Nº  xxx"),
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                            scrollable: true,
                            title: Text('BUSCAR OS'),
                            content: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Form(
                                child: TextFormField(
                                  controller: _numeroOsController,
                                  decoration: InputDecoration(
                                    icon: Icon(Icons.search),
                                  ),
                                ),
                              ),
                            ),
                            actions: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.blue,
                                  onPrimary: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(32.0),
                                  ),
                                ),
                                child: Text("IR"),
                                onPressed: () async {
                                  Response response;
                                  Dio dio = new Dio();
                                  String url =
                                      'http://192.168.15.2:8090/api/getOs';
                                  response = await dio.post(url, data: {
                                    "numeroos": _numeroOsController.text
                                  });

                                  print(response.statusCode);

                                  // final extractedData =
                                  //     jsonDecode(response.data)
                                  //         as Map<String, dynamic>;
                                  // final List<ProdutoOs> loadedProducts = [];
                                  // extractedData.forEach((key, value) {
                                  //   loadedProducts.add(ProdutoOs(
                                  //       cod_produto: value['Codigo_Produto'],
                                  //       qtd: value['Qtde'],
                                  //       desc: value['Descricao'],
                                  //       numOs: value['Numero_da_OS'],
                                  //       codOs: value['CodOS']));

                                  //   print(extractedData);
                                  // });

                                  // Map<dynamic, dynamic> map =
                                  //     jsonDecode(response.data);
                                  // print(map);

                                  // _pecasList =
                                  //     json.decode(response.toString());
                                  // print("Peças List:");
                                  // print(_pecasList)

                                  // Map<String, dynamic> map = jsonDecode(response);

                                  //print(response.data);

                                  Future loadProdutos() async {
                                    //  String jsonProdutos = response.data;
                                    //     final jsonResponse =
                                    //      json.decode(response.data);
                                    ProdutosList produtosList =
                                        ProdutosList.fromJson(response.data);
                                    print(produtosList.produtos[1].qtd);
                                    print(produtosList.produtos.length);
                                  }

                                  // ignore: unnecessary_statements

                                  setState(() {
                                    loadProdutos();
                                    Navigator.pop(context, true);
                                  });

                                  // var uuu = response.data;
                                  // print(uuu);

                                  // var maplist = await json
                                  //     .decode(uuu)
                                  //     .cast<Map<String, dynamic>>();
                                  // print(maplist);
                                },
                              )
                            ]);
                      });
                },
                child: Icon(
                  Icons.search,
                  size: 26.0,
                ),
              )),
        ],
      ),
      drawer: Drawer(
          elevation: 20.0,
          child: ListView(padding: EdgeInsets.zero, children: <Widget>[
            AppBar(
              backgroundColor: Colors.red,
              title: Text("Configurações"),
            ),
            ListTile(
                leading: Icon(Icons.person),
                title: Text('Usuário'),
                onTap: () {}
                //  async {
                //   final prefs = await SharedPreferences.getInstance();
                //   prefs.clear();
                //   setState(() {
                //     Navigator.of(context).pushReplacement(MaterialPageRoute(
                //         builder: (context) => LoginScreen()));
                ),
            ListTile(
                leading: Icon(Icons.remove_circle),
                title: Text('SAIR'),
                onTap: () {}
                //  async {
                //   final prefs = await SharedPreferences.getInstance();
                //   prefs.clear();
                //   setState(() {
                //     Navigator.of(context).pushReplacement(MaterialPageRoute(
                //         builder: (context) => LoginScreen()));
                )
          ])),
      body: Column(
        children: [
          Container(
            color: Colors.blue,
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 8,
                    child: Text(
                      "CLIENTE:",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Expanded(
                    flex: 8,
                    child: Text(
                      "STATUS:",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            color: Colors.blue,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 8.0, 0, 8.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Text("CÓDIGO",
                        style: TextStyle(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      "QTD",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      "FUNCIONÁRIO",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Text(
                      "DESCRIÇÃO",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Divider(
            height: 5.0,
          ),
          Expanded(
            child: ListView.builder(
                itemCount: produtosList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 4.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 2,
                          child: Text(
                            "12345",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            "12",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text("JOSE DA SILVA PEREIRA",
                              style: TextStyle(fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis
                              //ver
                              //https://santosenoque-ss.medium.com/how-to-connect-flutter-app-to-mysql-web-server-and-phpmyadmin-e100f47bfb82
                              //apaga
                              ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Text(
                              "DESCRIÇÃO DA PEÇA XXXXXX11111111 XXXXXXX",
                              style: TextStyle(fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis),
                        ),
                      ],
                    ),
                  );
                }),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    scrollable: true,
                    title: Text('ADICIONAR PEÇA'),
                    content: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Form(
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              decoration: InputDecoration(
                                icon: Icon(Icons.search),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    actions: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.blue,
                            onPrimary: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32.0),
                            ),
                          ),
                          child: Text("IR"),
                          onPressed: () {
                            // your code
                          }),
                    ],
                  );
                });
          },
          child: Icon(Icons.add)),
    );
  }
}
