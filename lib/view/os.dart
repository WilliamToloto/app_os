import 'package:flutter/material.dart';

class OS extends StatefulWidget {
  @override
  _OSState createState() => _OSState();
}

class _OSState extends State<OS> {
  @override
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
                    child: Text(
                      "CÓDIGO",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      "QTD",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: Text(
                      "FUNCIONÁRIO",
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
                itemCount: 3,
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
                          flex: 2,
                          child: Text(
                            "12",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          flex: 6,
                          child: Text(
                            "JOSE DA SILVA PEREIRA",
                            style: TextStyle(fontWeight: FontWeight.bold),
                            //ver
                            //https://santosenoque-ss.medium.com/how-to-connect-flutter-app-to-mysql-web-server-and-phpmyadmin-e100f47bfb82
                            //apaga
                          ),
                        ),
                      ],
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }
}
