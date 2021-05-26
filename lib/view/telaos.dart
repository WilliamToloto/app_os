//import 'dart:convert';
//import 'package:app_novo/control/func.dart';
import 'package:app_novo/model/funcionarios.dart';
import 'package:app_novo/model/produtoOs.dart';
import 'package:app_novo/view/login.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/funcionarios.dart';
import 'package:date_format/date_format.dart';

class OS extends StatefulWidget {
  @override
  _OSState createState() => _OSState();
}

String operadorLogado = "";
String nivelUsuario = "";
String removeapp = "";
String listaVazia = "";

class _OSState extends State<OS> {
  static _read() async {
    final prefs = await SharedPreferences.getInstance();
    final prefs1 = await SharedPreferences.getInstance();
    final prefs2 = await SharedPreferences.getInstance();
    final key = 'operador';
    final key1 = 'nivel';
    final key2 = 'removeapp';
    final value = prefs.getString(key);
    final value1 = prefs1.getString(key1);
    final value2 = prefs2.getString(key2);
    print('saved tester $value');
    print('nivel: $value1');
    print('removeapp: $value2');
    operadorLogado = value;
    nivelUsuario = value1;
    removeapp = value2;
    return operadorLogado;
  }

  String _scanBarcode = 'Unknown';

  Future<void> scanQR() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
    return _scanBarcode;
  }

  var funcioa1;
  List produtosList1 = <ProdutoOs>[];
  List funcionariosList = <Funcionarios>[];
  Funcionarios funcionarios;
  ProdutoOs produtoOs;
  var funcionarioDrop;
  var funcionarioDrop1;
  var produtoDesc;
  var osCod;
  var produtoCod;
  var dataExpirada;
  var numeroOS;
  // static const linkUrl = "http://192.168.1.66:8090/api/";
  static const linkUrl = "http://192.168.15.5:8090/api/";

  // LIST OF DROPDOWN MENU ITEMS;
  List<DropdownMenuItem> newFuncionariosList = [];

  Future loadFuncionarios() async {
    Response response;
    Dio dio = new Dio();
    String url = linkUrl + 'funcionarios';
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
  final _qtdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _read();

    WidgetsBinding.instance.addPostFrameCallback((_) => loadFuncionarios());
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
                                    //  keyboardType: TextInputType.datetime,
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
                                    BotToast.showText(
                                        text: "AGUARDE A BUSCA",
                                        duration: Duration(milliseconds: 2000),
                                        clickClose: false,
                                        backgroundColor: Colors.black26);

                                    if (_numeroOsController.text.isEmpty) {
                                      BotToast.showText(
                                          text: "CAMPO VAZIO",
                                          clickClose: true,
                                          backgroundColor: Colors.black26);
                                    } else {
                                      Response response;
                                      Dio dio = new Dio();
                                      String url = linkUrl + 'getOs';
                                      try {
                                        await dio.get(url);
                                      } on DioError catch (e) {
                                        if (e.response != null) {
                                          print(e.response.data);
                                        } else {
                                          BotToast.showText(
                                              text: "FALHA NA CONEXÃO",
                                              duration:
                                                  Duration(milliseconds: 2000),
                                              clickClose: true,
                                              backgroundColor: Colors.black26);
                                        }
                                      }
                                      // 'http://192.168.15.2:8090/api/getOs';
                                      response = await dio.post(url, data: {
                                        "numeroos": _numeroOsController.text
                                      });
                                      print(response.statusCode);
                                      if (response.data == "not_found") {
                                        Response response;
                                        Dio dio = new Dio();
                                        String url = linkUrl + 'getOs0';
                                        try {
                                          await dio.get(url);
                                        } on DioError catch (e) {
                                          if (e.response != null) {
                                            print(e.response.data);
                                          } else {
                                            BotToast.showText(
                                                text: "FALHA NA CONEXÃO",
                                                duration: Duration(
                                                    milliseconds: 2000),
                                                clickClose: true,
                                                backgroundColor:
                                                    Colors.black26);
                                          }
                                        }
                                        // 'http://192.168.15.2:8090/api/getOs';
                                        response = await dio.post(url, data: {
                                          "numeroos": _numeroOsController.text
                                        });

                                        if (response.data == "not_found") {
                                          BotToast.showText(
                                              text: "OS não encontrada",
                                              clickClose: true,
                                              backgroundColor: Colors.black26);
                                        } else {
                                          numeroOS = _numeroOsController.text;
                                          print(
                                              "Numero OS tirado do controller");
                                          print(numeroOS);
                                          print(response.data[0]['status']);
                                          print(
                                              response.data[0]['DataPrevisao']);
                                          print(response.data[0]['CodCliente']);
                                          print(
                                              response.data[0]['Numero_da_OS']);
                                          print(response.data[0]['CodOS']);
                                          print(response.data[0]);
                                          ProdutosList produtosList =
                                              ProdutosList.fromJson(
                                                  response.data);
                                          print(produtosList.produtos[0].qtd);
                                          print(produtosList.produtos.length);
                                          produtosList1 = produtosList.produtos;
                                          print(produtosList1[0].codOs);
                                          osCod =
                                              produtosList.produtos[0].codOs;

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
                                          if (dataExpirada == "s") {
                                            BotToast.showText(
                                                text:
                                                    "DATA DE PREVISÃO JÁ ATINGIDA",
                                                align: Alignment(0, 0),
                                                clickClose: true,
                                                contentColor: Colors.red,
                                                backgroundColor:
                                                    Colors.black26);
                                          }

                                          setState(() {
                                            print(dataPrevisao);

                                            _numeroOsController.clear();
                                            Navigator.pop(context, true);
                                          });
                                        }
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
                                          osCod =
                                              produtosList.produtos[0].codOs;
                                        }

                                        setState(() {
                                          loadProdutos();

                                          Navigator.pop(context, true);
                                          numeroOS = _numeroOsController.text;
                                          print(
                                              "Numero OS tirado do controller");
                                          print(numeroOS);
                                          _numeroOsController.clear();
                                          if (dataExpirada == "s") {
                                            BotToast.showText(
                                                text:
                                                    "DATA DE PREVISÃO JÁ ATINGIDA",
                                                align: Alignment(0, 0),
                                                clickClose: true,
                                                contentColor: Colors.red,
                                                backgroundColor:
                                                    Colors.black26);
                                          }
                                        });
                                      }
                                    }
                                  },
                                )
                              ]);
                        });
                  },
                  child: Icon(Icons.search, size: 26.0),
                ))
          ]),
      drawer: Container(
          color: Colors.blue.shade300,
          child: ListView(padding: EdgeInsets.zero, children: <Widget>[
            AppBar(
              leading: GestureDetector(
                  child: Icon(
                    Icons.toc_outlined,
                    color: Colors.blue,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  }),
              backgroundColor: Colors.white,
              title: Text("Opções", style: TextStyle(color: Colors.blue)),
            ),
            SizedBox(
              height: 40.0,
            ),
            ListTile(
                leading: Icon(
                  Icons.person,
                  color: Colors.white,
                ),
                title:
                    Text(operadorLogado, style: TextStyle(color: Colors.white)),
                onTap: () {}),
            ListTile(
                leading: Icon(
                  Icons.remove_circle,
                  color: Colors.white,
                ),
                title: Text('SAIR', style: TextStyle(color: Colors.white)),
                onTap: () async {
                  final prefs = await SharedPreferences.getInstance();
                  final prefs1 = await SharedPreferences.getInstance();
                  final prefs2 = await SharedPreferences.getInstance();
                  //final prefs3 = await SharedPreferences.getInstance();
                  prefs.clear();
                  prefs1.clear();
                  prefs2.clear();
                  // perfs3.clear();
                  setState(() {
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => Login()));
                  });
                }),
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
                    ]),
                    Row(children: [
                      Text(
                        "Data Previsão:  ${(produtosList1.isEmpty || produtosList1[0].status == null) ? " --- " : formatDate(DateTime.parse(produtosList1[0].dataPrevisao), [
                            d,
                            '/',
                            mm,
                            '/',
                            yy,
                            ' - ',
                            HH,
                            ' ',
                            nn
                          ])}",
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
                      child: InkWell(
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 2,
                                child: Text(
                                  produtosList1.isEmpty ||
                                          produtosList1[index].codProd == null
                                      ? " "
                                      : produtosList1[index].codProd,
                                  // : produtosList1[index].cod_produto,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  //produtosList1[index].qtd.toString(),
                                  produtosList1.isEmpty ||
                                          produtosList1[index].qtd == "" ||
                                          produtosList1[index].qtd == "null"
                                      ? ""
                                      : produtosList1[index].qtd,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Expanded(
                                flex: 4,
                                child: Text(
                                    produtosList1[index].funcionario == null
                                        ? " "
                                        : produtosList1[index].funcionario,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis),
                              ),
                              Expanded(
                                flex: 4,
                                child: Text(
                                    produtosList1.isEmpty ||
                                            produtosList1[index].desc == null
                                        ? " "
                                        : produtosList1[index].desc,
                                    //produtosList1[index].desc,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12),
                                    overflow: TextOverflow.ellipsis),
                              ),
                            ],
                          ),
                          onLongPress: () {
                            if ((removeapp == '1') &&
                                (dataExpirada == "n") &&
                                (produtosList1[0].status != "Fechado")) {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    // retorna um objeto do tipo Dialog
                                    return AlertDialog(
                                        title: Text("Remoção de Peça"),
                                        content: Text(
                                            "Deseja realmente remover a peça " +
                                                produtosList1[index].desc +
                                                "?"),
                                        actions: <Widget>[
                                          TextButton(
                                            child: Text("NÃO"),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          TextButton(
                                              child: Text("SIM"),
                                              onPressed: () async {
                                                Response response;
                                                Dio dio = Dio();
                                                String url =
                                                    linkUrl + 'deleteProduto';
                                                try {
                                                  await dio.get(url);
                                                } on DioError catch (e) {
                                                  if (e.response != null) {
                                                    print(e.response.data);
                                                  } else {
                                                    BotToast.showText(
                                                        text:
                                                            "FALHA NA CONEXÃO",
                                                        duration: Duration(
                                                            milliseconds: 2000),
                                                        clickClose: true,
                                                        backgroundColor:
                                                            Colors.black26);
                                                  }
                                                }
                                                response =
                                                    await dio.post(url, data: {
                                                  "CodOs": produtosList1[index]
                                                      .codOs,
                                                  "CodProduto":
                                                      produtosList1[index]
                                                          .cod_produto,
                                                  "CodFuncionario":
                                                      produtosList1[index]
                                                          .codFuncionario
                                                });
                                                Response response1;
                                                Dio dio1 = new Dio();
                                                String url1 = linkUrl + 'getOs';
                                                response1 = await dio1
                                                    .post(url1, data: {
                                                  "numeroos": numeroOS
                                                  // data: {"numeroos": osCod});
                                                });

                                                if (response1.data ==
                                                    "not_found") {
                                                  Response response2;
                                                  Dio dio = new Dio();
                                                  String url =
                                                      linkUrl + 'getOs0';
                                                  // 'http://192.168.15.2:8090/api/getOs';
                                                  response2 = await dio
                                                      .post(url, data: {
                                                    "numeroos": numeroOS
                                                  });
                                                  print(response2.data);

                                                  ProdutosList produtosList =
                                                      ProdutosList.fromJson(
                                                          response2.data);

                                                  produtosList1 =
                                                      produtosList.produtos;

                                                  osCod = produtosList
                                                      .produtos[0].codOs;

                                                  Future loadProdutos() async {
                                                    ProdutosList produtosList =
                                                        ProdutosList.fromJson(
                                                            response2.data);
                                                    produtosList1 =
                                                        produtosList.produtos;
                                                  }

                                                  setState(() {
                                                    loadProdutos();
                                                  });
                                                } else {
                                                  Future loadProdutos() async {
                                                    ProdutosList produtosList =
                                                        ProdutosList.fromJson(
                                                            response1.data);
                                                    produtosList1 =
                                                        produtosList.produtos;
                                                  }

                                                  setState(() {
                                                    loadProdutos();
                                                  });
                                                  print(response.data);
                                                  Navigator.of(context).pop();
                                                }
                                              })
                                        ]);
                                  });
                            } else {
                              BotToast.showText(
                                  text: produtosList1[index].desc,
                                  clickClose: true,
                                  backgroundColor: Colors.black26,
                                  align: Alignment(0, 0));
                            }
                          }));
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
                    hint: Text('Selecionar Funcionário '),
                    onChanged: (value) {
                      print("VALUE DO DROPDOWN $value");
                      funcionarioDrop = value[0];
                      funcionarioDrop1 = value[1];
                      print(funcionarioDrop);
                    },
                    items: newFuncionariosList,
                  ),
                ),
                Divider(
                  height: 6.0, //
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: TextFormField(
                        // keyboardType: TextInputType.datetime,
                        controller: _codprodController,
                        decoration: InputDecoration(
                          hintText: ("Codigo da peça"),
                          hintStyle: TextStyle(color: Colors.black38),
                          icon: Icon(
                            Icons.keyboard,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blueAccent[400],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32.0),
                          ),
                        ),
                        child:
                            //Text("IR"),
                            Icon(Icons.filter_alt_outlined),
                        onPressed: () async {
                          Response response;
                          Dio dio = new Dio();
                          // String url = 'http://192.168.1.66:8090/api/getPeca';
                          String url = linkUrl + 'getPeca';
                          //verificar conexão API/Banco de dados
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

                            setState(() {});
                          }
                        },
                      ),
                    ),
                    Expanded(
                        flex: 1,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.blueAccent[400],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(32.0),
                              ),
                            ),
                            onPressed: () async {
                              if (funcionarioDrop != null) {
                                await scanQR();

                                print("Barcode abaixo");
                                print(_scanBarcode);
                                Response response;
                                Dio dio = new Dio();
                                // String url = 'http://192.168.1.66:8090/api/getPeca';
                                String url = linkUrl + 'getPeca';
                                //verificar conexão API/Banco de dados
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
                                response = await dio
                                    .post(url, data: {"codprod": _scanBarcode});
                                print(response.statusCode);
                                print(response.data);

                                if (response.data == 'not_found') {
                                  BotToast.showText(
                                      duration: Duration(seconds: 2),
                                      text: "Peça não encontrada",
                                      clickClose: false,
                                      backgroundColor: Colors.black26,
                                      align: Alignment(0, 0));
                                } else {
                                  produtoDesc =
                                      response.data[0]['Descricao'].toString();
                                  produtoCod =
                                      response.data[0]['Codigo'].toString();

                                  if ((nivelUsuario == "MASTER" ||
                                          dataExpirada == "n") &&
                                      (produtosList1[0].status != "Fechado")) {
                                    Response response;
                                    Dio dio = new Dio();
                                    String url = linkUrl + 'addProduto';
                                    response = await dio.post(url, data: {
                                      "CodOs": osCod,
                                      "CodProduto": produtoCod,
                                      "Qtde": _qtdController.text.isEmpty
                                          ? 1
                                          : _qtdController.text,
                                      "ValorUnitario": 1.00,
                                      "CodFuncionario": funcionarioDrop,
                                      "Sub": 1.00,
                                      "Tipo": "A",
                                      "Operador": operadorLogado,
                                      "valorantigo": 1.00,
                                      "Custounit": 1.00
                                    });

                                    if (response.data == "Ok!") {
                                      print("Response OK");
                                      Response response1;
                                      Dio dio = new Dio();
                                      String url = linkUrl + 'updateCusto';
                                      response1 = await dio.post(url, data: {
                                        "CodOs": osCod,
                                        "CodProduto": produtoCod
                                      });
                                      print(response1.data);
                                      BotToast.showSimpleNotification(
                                          title: "Item Adicionado");
                                      _qtdController.clear();
                                      _codprodController.clear();
                                      produtoDesc = null;
                                    } else if (response.data['error']
                                                ['originalError']['info']
                                            ['number'] ==
                                        2627) {
                                      print(
                                          "Item já adicionado, foi somado ao existente");
                                      //Faz o update
                                      Response response;
                                      Dio dio = new Dio();
                                      String url = linkUrl + 'updateProduto';
                                      response = await dio.post(url, data: {
                                        "CodOs": osCod,
                                        "CodProduto": produtoCod,
                                        "Qtde": _qtdController.text.isEmpty
                                            ? 1
                                            : _qtdController.text,
                                        "CodFuncionario": funcionarioDrop,
                                        "Operador": operadorLogado,
                                      });
                                      print(response.data);
                                      BotToast.showSimpleNotification(
                                          title: "Item Atualizado");
                                      _qtdController.clear();
                                      _codprodController.clear();
                                      produtoDesc = null;
                                    } else {
                                      print("erro");
                                      BotToast.showSimpleNotification(
                                          title: "ERRO");
                                    }

                                    Response response1;
                                    Dio dio1 = new Dio();
                                    String url1 = linkUrl + 'getOs';
                                    response1 = await dio1.post(url1,
                                        data: {"numeroos": numeroOS});

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
                                        text:
                                            "Não é possível realizar alterações",
                                        align: Alignment(0, 0),
                                        clickClose: true,
                                        contentColor: Colors.red,
                                        backgroundColor: Colors.black26);
                                  }

                                  setState(() {});
                                }
                              } else {
                                BotToast.showText(
                                    duration: Duration(seconds: 2),
                                    text: "PREENCHER FUNCIONÁRIO",
                                    clickClose: false,
                                    backgroundColor: Colors.black26,
                                    align: Alignment(0, 0));
                              }
                            },
                            child: Icon(Icons.qr_code_scanner)))
                  ],
                ),
                Divider(
                  height: 8.0,
                ),
                Row(
                  children: [
                    Expanded(
                        flex: 6,
                        child: Text(
                          produtoDesc == null ? "- - -" : produtoDesc,
                          overflow: TextOverflow.ellipsis,
                        )),
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        controller: _qtdController,
                        decoration: InputDecoration(
                          hintText: "qtd",
                          hintStyle: TextStyle(color: Colors.black38),
                        ),
                      ),
                    ),
                    Expanded(
                        flex: 2,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.green[600], // background
                              onPrimary: Colors.lightGreen[50], // foreground
                            ),
                            child: Icon(
                                Icons.add), //verifica se não tem nada vazio
                            onPressed: (_qtdController.text.isEmpty ||
                                    produtoDesc == null ||
                                    funcionarioDrop == null)
                                ? null
                                : () async {
                                    if ((nivelUsuario == "MASTER" ||
                                            dataExpirada == "n") &&
                                        (produtosList1[0].status !=
                                            "Fechado")) {
                                      Response response;
                                      Dio dio = new Dio();
                                      String url = linkUrl + 'addProduto';
                                      try {
                                        await dio.get(url);
                                      } on DioError catch (e) {
                                        if (e.response != null) {
                                          print(e.response.data);
                                        } else {
                                          BotToast.showText(
                                              text: "FALHA NA CONEXÃO",
                                              duration:
                                                  Duration(milliseconds: 2000),
                                              clickClose: true,
                                              backgroundColor: Colors.black26);
                                        }
                                      }
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

                                      if (response.data == "Ok!") {
                                        print("Response OK");
                                        Response response1;
                                        Dio dio = new Dio();
                                        String url = linkUrl + 'updateCusto';
                                        response1 = await dio.post(url, data: {
                                          "CodOs": osCod,
                                          "CodProduto": produtoCod
                                        });
                                        print(response1.data);
                                        BotToast.showSimpleNotification(
                                            title: "Item Adicionado");
                                        _qtdController.clear();
                                        _codprodController.clear();
                                        produtoDesc = null;
                                        // _codprodController.clear();
                                        // produtoCod = "";
                                      } else if (response.data['error']
                                                  ['originalError']['info']
                                              ['number'] ==
                                          2627) {
                                        print("ERRO DE CHAVE PRIMÁRIA");
                                        //Faz o update
                                        Response response;
                                        Dio dio = new Dio();
                                        String url = linkUrl + 'updateProduto';
                                        //verificar conexão API/Banco de dados
                                        try {
                                          await dio.get(url);
                                        } on DioError catch (e) {
                                          if (e.response != null) {
                                            print(e.response.data);
                                          } else {
                                            BotToast.showText(
                                                text: "FALHA NA CONEXÃO",
                                                duration: Duration(
                                                    milliseconds: 2000),
                                                clickClose: true,
                                                backgroundColor:
                                                    Colors.black26);
                                          }
                                        }
                                        response = await dio.post(url, data: {
                                          "CodOs": osCod,
                                          "CodProduto": produtoCod,
                                          "Qtde": _qtdController.text,
                                          "CodFuncionario": funcionarioDrop,
                                          "Operador": operadorLogado,
                                        });
                                        print(response.data);
                                        BotToast.showSimpleNotification(
                                            title: "Item Atualizado");
                                        _qtdController.clear();
                                        _codprodController.clear();
                                        produtoDesc = null;
                                      } else {
                                        print("erro");
                                        BotToast.showSimpleNotification(
                                            title: "ERRO");
                                      }

                                      Response response1;
                                      Dio dio1 = new Dio();
                                      String url1 = linkUrl + 'getOs';
                                      response1 = await dio1.post(url1, data: {
                                        "numeroos": numeroOS
                                        // data: {"numeroos": osCod});
                                      });

                                      print("controller text");
                                      print(numeroOS);

                                      Future loadProdutos() async {
                                        ProdutosList produtosList =
                                            ProdutosList.fromJson(
                                                response1.data);
                                        produtosList1 = produtosList.produtos;
                                      }

                                      setState(() {
                                        loadProdutos();
                                      });
                                    } else {
                                      BotToast.showText(
                                          text:
                                              "Não é possível realizar alterações",
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
