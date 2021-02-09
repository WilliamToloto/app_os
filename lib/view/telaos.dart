import 'dart:convert';
import 'package:app_novo/model/dropdownitens.dart';
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

class _OSState extends State<OS> {
  static _read() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'operador';
    final value = prefs.getString(key);
    print('saved tester $value');
    String operadorLogado = value;
    return operadorLogado;
  }

  var funcioa1;
  List produtosList1 = <ProdutoOs>[];
  int _value = 1;
  List funcionariosList = <Funcionarios>[];
  Funcionarios funcionarios;
  //List itensDrop = [];
  //List _func = [];

  // LIST OF DROPDOWN MENU ITEMS;
  List<DropdownMenuItem> newFuncionariosList = [];

  Future loadFuncionarios() async {
    Response response;
    Dio dio = new Dio();
    String url = 'http://192.168.15.5:8090/api/funcionarios';
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
          value: element.codigo,
        ),
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
                                        'http://192.168.15.5:8090/api/getOs';
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
                                        //  String jsonProdutos = response.data;
                                        //     final jsonResponse =
                                        //      json.decode(response.data);
                                        ProdutosList produtosList =
                                            ProdutosList.fromJson(
                                                response.data);
                                        print(produtosList.produtos[0].qtd);
                                        print(produtosList.produtos.length);
                                        produtosList1 = produtosList.produtos;
                                        print(produtosList1[0].desc);
                                        print(produtosList1[0].cod_produto);
                                      }

                                      setState(() {
                                        loadProdutos();
                                        Navigator.pop(context, true);
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
                onTap: () async {
                  final prefs = await SharedPreferences.getInstance();
                  prefs.clear();
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
                    Row(
                      children: [
                        Text(
                          "STATUS:  ${(produtosList1.isEmpty || produtosList1[0].status == null) ? " --- " : produtosList1[0].status}",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    )
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
                    ),
                  ),
                  Expanded(
                    flex: 4,
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
                                : produtosList1[index].cod_produto,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            //"2"
                            produtosList1.isEmpty
                                ? "data is empty"
                                : produtosList1[index].qtd,
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
                              controller: _codprodController,
                              decoration: InputDecoration(
                                icon: Icon(Icons.add),
                              ),
                            ),
                            TextFormField(
                              controller: _codprodqtdController,
                              decoration: InputDecoration(
                                icon: Icon(Icons.add),
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
                        onPressed: () async {
                          Response response;
                          Dio dio = new Dio();
                          String url = 'http://192.168.15.5:8090/api/getPeca';
                          response = await dio.post(url,
                              data: {"codprod": _codprodController.text});
                          print(response.statusCode);
                          print(response.data);
                        },
                      ),
                    ],
                  );
                });
          },
          child: Icon(Icons.add)),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 140.0,
          color: Colors.blue[400],
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(children: [
              Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                ),

// hot restart please
                child: Container(
                  height: 70,
                  child: DropdownButtonFormField(
                    hint: Text('Choose '),
                    onChanged: (value) {
                      print(value);
                      // here you can pass it to a variable for example
                    },
                    items: newFuncionariosList,
                  ),
                ),
              ),
              Container(
                  color: Colors.red,
                  child: ElevatedButton(
                    onPressed: () async {
                      Response response;
                      Dio dio = new Dio();
                      String url = 'http://192.168.15.5:8090/api/funcionarios';
                      // 'http://192.168.15.2:8090/api/getOs';
                      response = await dio.post(url);
                      print(response.statusCode);
                      print(response.data);
                    },
                    child: (Text("Teste")),
                  )),
            ]),
          ),
        ),
      ),
    );
  }
}
