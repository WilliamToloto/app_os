import 'dart:convert';
import 'package:app_novo/model/funcionarios.dart';
import 'package:app_novo/model/produtoOs.dart';
import 'package:app_novo/view/login.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/funcionarios.dart';

class OS extends StatefulWidget {
  @override
  _OSState createState() => _OSState();
}

String operadorLogado = "";
String nivelUsuario = "";

class _OSState extends State<OS> {
  static _read() async {
    final prefs = await SharedPreferences.getInstance();
    final prefs1 = await SharedPreferences.getInstance();
    final key = 'operador';
    final key1 = 'nivel';
    final value = prefs.getString(key);
    final value1 = prefs1.getString(key1);
    print('saved tester $value');
    print('nivel: $value1');
    operadorLogado = value;
    nivelUsuario = value1;
    return operadorLogado;
  }

  var funcioa1;
  List produtosList1 = <ProdutoOs>[];
  int _value = 1;
  List funcionariosList = <Funcionarios>[];
  Funcionarios funcionarios;
  ProdutoOs produtoOs;
  var funcionarioDrop;
  var funcionarioDrop1;
  var produtoDesc;
  var osCod;
  var produtoCod;
  var dataExpirada;

  // LIST OF DROPDOWN MENU ITEMS;
  List<DropdownMenuItem> newFuncionariosList = [];

  Future loadFuncionarios() async {
    Response response;
    Dio dio = new Dio();
    String url = 'http://192.168.15.2:8090/api/funcionarios';
    response = await dio.post(url);

    FuncionariosList funcionariosList =
        FuncionariosList.fromJson(response.data);

    // CREATING A DROPDOWN MENU ITEM FOR EACH ELEEMENT
    funcionariosList.funcionarios.forEach((element) {
      newFuncionariosList.add(
        DropdownMenuItem(
            child: Text(
              '${element.nome}',
              style: TextStyle(fontSize: 16),
            ),
            value: [element.codigo, element.nome]),
      );
    });
    print(newFuncionariosList);
    setState(() {
      newFuncionariosList = newFuncionariosList;
    });
    print(funcionariosList.funcionarios[0].nome);
    print(funcionariosList.funcionarios.length);
  }

  final _numeroOsController = TextEditingController();
  final _codprodController = TextEditingController();
  final _codprodqtdController = TextEditingController();
  final _qtdPecaController = TextEditingController();
  final _qtdController = TextEditingController();
  //final _codPecaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _read();

    //loadFuncionarios();
    WidgetsBinding.instance.addPostFrameCallback((_) => loadFuncionarios());
    // final prefs = await SharedPreferences.getInstance();
    // final key = 'usuario';
    // final value = prefs.getString(key);
    // print('saved $value');
  }

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          "OS  Nº  ${produtosList1.isEmpty ? " --- " : produtosList1[0].numOs}",
        ),
        //+ produtosList1[0].cod_produto),
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
                                  if (_numeroOsController.text.isEmpty) {
                                    BotToast.showText(
                                        text: "CAMPO VAZIO",
                                        clickClose: true,
                                        backgroundColor: Colors.black26);
                                  } else {
                                    Response response;
                                    Dio dio = new Dio();
                                    String url =
                                        'http://192.168.15.2:8090/api/getOs';
                                    // 'http://192.168.15.2:8090/api/getOs';
                                    response = await dio.post(url, data: {
                                      "numeroos": _numeroOsController.text
                                    });

                                    print(response.statusCode);

                                    if (response.data == "not_found") {
                                      BotToast.showText(
                                          text: "OS não encontrada",
                                          clickClose: true,
                                          backgroundColor: Colors.black26);
                                    } else {
                                      Future loadProdutos() async {
                                        ProdutosList produtosList =
                                            ProdutosList.fromJson(
                                                response.data);
                                        print(produtosList.produtos[0].qtd);
                                        print(produtosList.produtos.length);
                                        produtosList1 = produtosList.produtos;
                                        print(produtosList1[0].desc);
                                        print(produtosList1[0].cod_produto);
                                        print(produtosList1[0].codProd);

                                        String dataPrevisao = produtosList
                                            .produtos[0].dataPrevisao;
                                        DateTime.parse(dataPrevisao);
                                        print(dataPrevisao);
                                        if (DateTime.now().isBefore(
                                            DateTime.parse(dataPrevisao))) {
                                          print("eh menor");
                                          dataExpirada = "n";
                                        } else {
                                          dataExpirada = "s";
                                        }
                                        osCod = produtosList.produtos[0].codOs;
                                      }

                                      setState(() {
                                        loadProdutos();
                                        Navigator.pop(context, true);
                                        if (dataExpirada == "s") {
                                          BotToast.showText(
                                              text:
                                                  "DATA DE PREVISÃO JÁ ATINGIDA",
                                              align: Alignment(0, 0),
                                              clickClose: true,
                                              contentColor: Colors.red,
                                              backgroundColor: Colors.black26);
                                        }
                                      });
                                    }
                                  }
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
                title: Text(operadorLogado),
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
                onTap: () async {
                  final prefs = await SharedPreferences.getInstance();
                  final prefs1 = await SharedPreferences.getInstance();
                  prefs.clear();
                  prefs1.clear();

                  setState(() {
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => Login()));
                  });
                })
          ])),
      body: Column(
        children: [
          Container(
            color: Colors.blue,
            child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Column(
                  children: [
                    Row(children: [
                      Text(
                          "CLIENTE:  ${(produtosList1.isEmpty || produtosList1[0].cliente == null) ? " --- " : produtosList1[0].cliente}",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis),
                    ]),
                    Row(children: [
                      Text(
                        "STATUS:  ${(produtosList1.isEmpty || produtosList1[0].status == null) ? " --- " : produtosList1[0].status}",
                        style: TextStyle(color: Colors.white),
                      )
                    ])
                  ],
                )),
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
                        )),
                    Expanded(
                        flex: 4,
                        child: Text(
                          "FUNCIONÁRIO",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                    Expanded(
                        flex: 4,
                        child: Text(
                          "DESCRIÇÃO",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                  ],
                )),
          ),
          Divider(
            height: 5.0,
          ),
          Expanded(
            child: ListView.builder(
                itemCount: produtosList1.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 4.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 2,
                          child: Text(
                            produtosList1.isEmpty
                                ? "data is empty"
                                : produtosList1[index].codProd,
                            // : produtosList1[index].cod_produto,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            produtosList1[index].qtd.toString(),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Text(
                              produtosList1[index].funcionario == null
                                  ? "-"
                                  : produtosList1[index].funcionario,
                              style: TextStyle(fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis),
                        ),
                        Expanded(
                          flex: 4,
                          child: Text(
                              produtosList1.isEmpty
                                  ? "data is empty"
                                  : produtosList1[index].desc,
                              //produtosList1[index].desc,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 12),
                              overflow: TextOverflow.ellipsis),
                        ),
                      ],
                    ),
                  );
                }),
          )
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Form(
          child: Container(
            height: 180.0 + MediaQuery.of(context).viewInsets.bottom,
            color: Colors.blue[400],
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(children: [
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: DropdownButtonFormField(
                    hint: Text('Choose '),
                    onChanged: (value) {
                      print("VALUE DO DROPDOWN $value");
                      funcionarioDrop = value[0];
                      funcionarioDrop1 = value[1];
                      print(funcionarioDrop);
                      // var funcionarioDrop = value;
                      // here you can pass it to a variable for example
                    },
                    items: newFuncionariosList,
                  ),
                ),
                Divider(
                  height: 6.0,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: _codprodController,
                        decoration: InputDecoration(
                          icon: Icon(Icons.add),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: ElevatedButton(
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
                          String url = 'http://192.168.15.2:8090/api/getPeca';
                          response = await dio.post(url,
                              data: {"codprod": _codprodController.text});
                          print(response.statusCode);
                          print(response.data);
                          if (response.data == 'not_found') {
                            BotToast.showText(
                                text: "Peça não encontrada",
                                clickClose: true,
                                backgroundColor: Colors.black26,
                                align: Alignment(0, 0));
                          } else {
                            produtoDesc =
                                response.data[0]['Descricao'].toString();
                            produtoCod = response.data[0]['Codigo'].toString();
                            // produtosList1.add(new ProdutoOs(
                            //     cod_produto:
                            //         response.data[0]['Codigo'].toString(),
                            //     qtd: 24, //int.parse(_qtdPecaController.text),
                            //     desc: response.data[0]['Descricao'].toString(),
                            //     numOs: "produtosList1[0].numOs",
                            //     codOs: produtosList1[0].codOs,
                            //     funcionario: funcionarioDrop1,
                            //     cliente: "produtosList1[0].cliente",
                            //     status: 'produtosList1[0].status')
                            //  );
                            //adiciona na lista local
                            setState(() {});
                          }
                        },
                      ),
                    )
                  ],
                ),
                Divider(
                  height: 8.0,
                ),
                Row(
                  children: [
                    Expanded(
                        flex: 6,
                        child: Text(produtoDesc == null ? "- - -" : produtoDesc,
                            overflow: TextOverflow.ellipsis)),
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        controller: _qtdController,
                        decoration: InputDecoration(hintText: "qtd"),
                      ),
                    ),
                    Expanded(
                        flex: 2,
                        child: ElevatedButton(
                            child: Icon(Icons.add),
                            onPressed: () async {
                              if ((nivelUsuario == "MASTER" ||
                                      dataExpirada == "n") &&
                                  (produtosList1[0].status != "Fechado")) {
                                Response response;
                                Dio dio = new Dio();
                                String url =
                                    'http://192.168.15.2:8090/api/addProduto';
                                response = await dio.post(url, data: {
                                  "CodOs": osCod,
                                  "CodProduto": produtoCod,
                                  "Qtde": _qtdController.text,
                                  "ValorUnitario": 1.00,
                                  "CodFuncionario": funcionarioDrop,
                                  "Sub": 1.00,
                                  "Tipo": "A",
                                  "Operador": operadorLogado,
                                  "valorantigo": 1.00,
                                  "Custounit": 1.00
                                });
                                print(response.statusCode);
                                print(response.data);
                                //print(response.data['error']['originalError']
                                //      ['info']['message']);
                                //pega erro de chave primária
                                // var respostajson = (response.data.toString());
                                //  print(respostajson[5]);
                                //['code'].toString());

                                if (response.data == "Ok!") {
                                  print("OK caraiiii");
                                  Response response1;
                                  Dio dio = new Dio();
                                  String url =
                                      'http://192.168.15.2:8090/api/updateCusto';
                                  response1 = await dio.post(url, data: {
                                    "CodOs": osCod,
                                    "CodProduto": produtoCod
                                  });
                                  print(response1.data);
                                } else if (response.data['error']
                                        ['originalError']['info']['number'] ==
                                    2627) {
                                  print("ERRO DE CHAVE PRIMÁRIA");
                                  //Faz o update
                                  Response response;
                                  Dio dio = new Dio();
                                  String url =
                                      'http://192.168.15.2:8090/api/updateProduto';
                                  response = await dio.post(url, data: {
                                    "CodOs": osCod,
                                    "CodProduto": produtoCod,
                                    "Qtde": _qtdController.text,
                                    "CodFuncionario": funcionarioDrop,
                                    "Operador": operadorLogado,
                                  });
                                  print(response.data);
                                } else {
                                  print("erro");
                                }

                                Response response1;
                                Dio dio1 = new Dio();
                                String url1 =
                                    'http://192.168.15.2:8090/api/getOs';
                                response1 = await dio1.post(url1, data: {
                                  "numeroos": _numeroOsController.text
                                });

                                Future loadProdutos() async {
                                  ProdutosList produtosList =
                                      ProdutosList.fromJson(response1.data);
                                  produtosList1 = produtosList.produtos;
                                }

                                setState(() {
                                  loadProdutos();
                                });
                              } else {
                                BotToast.showText(
                                    text: "Não é possível realizar alterações",
                                    align: Alignment(0, 0),
                                    clickClose: true,
                                    contentColor: Colors.red,
                                    backgroundColor: Colors.black26);
                              }
                            }))
                  ],
                )
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
