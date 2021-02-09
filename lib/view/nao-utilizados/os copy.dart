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
                onTap: () {},
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Column(
                  children: [
                    Text(
                      "Cliente: VINICOLOR IND E COM",
                      style: TextStyle(fontSize: 16),
                    )
                  ],
                ),
                SizedBox(
                  height: 20.0,
                  width: 20.0,
                ),
                Column(
                  children: [
                    Text(
                      "Status: FECHADO",
                      style: TextStyle(fontSize: 16),
                    )
                  ],
                ),
              ],
            ),
          ),
          Divider(
            height: 05.0,
          ),
          ListTile(
            title: Text(("COD: 1001327 - QTD: 04 - FUNC.: LUIZ FERNANDO")),
          ),
          ListTile(
            title: Text(("COD: 1001329 - QTD: 01 - FUNC.: JOSE DA SILVA")),
          ),
          ListTile(
            title: Text(("COD: 1001330 - QTD: 05 - FUNC.: AAAAAAA")),
          ),
          ListTile(
            title: Text(("COD: 1001332 - QTD: 05 - FUNC.: BBBBBBB")),
          ),
          ListTile(
            title: Text(("COD: 1001336 - QTD: 05 - FUNC.: JOSE DA SILVA")),
          ),
        ],
      ),
    );
  }
}
