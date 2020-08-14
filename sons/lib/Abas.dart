import 'package:flutter/material.dart';

import 'PrimeiraPagina.dart';
import 'SegundaPagina.dart';
import 'TerceiraPagina.dart';

class Abas extends StatefulWidget {
  @override
  _AbasState createState() => _AbasState();
}

class _AbasState extends State<Abas> with SingleTickerProviderStateMixin {

  TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _tabController = TabController(
        length: 3,
        vsync: this,
      initialIndex: 0
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Abas"),
        bottom: TabBar(
          controller: _tabController,
            tabs: <Widget>[
              Tab(
                //text: "Home",
                icon: Icon(Icons.home),
              ),
              Tab(
                //text: "Email",
                  icon: Icon(Icons.email),
              ),
              Tab(
                //text: "Conta",
                  icon: Icon(Icons.account_circle),
              )
            ]
        )
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          PrimeiraPagina(),
          SegundaPagina(),
          TerceiraPagina()
        ],
      ),
    );
  }
}
