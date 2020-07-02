import 'package:flutter/material.dart';

class Inventario_home extends StatelessWidget {
  const Inventario_home({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Color(0xFFFCFAF8),
      body: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 100.0),
            width: MediaQuery.of(context).size.width - 30.0,
            height: MediaQuery.of(context).size.height - 50.0,
            child: GridView.count(
                crossAxisCount: 2,
                primary: false,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 15.0,
                childAspectRatio: 0.8,
                children: <Widget>[
                  _buildCard('INVENTARIO', 'invent', context),
                  _buildCard('COMPRA', 'invent', context),
                  _buildCard('VENTA', 'invent', context),
                  _buildCard('REPORTES', 'invent', context)
                ],
              )),
        ],
      ),
    );
  }

  Widget _buildCard(String name, String direccion, context) {
    return Padding(
        padding: EdgeInsets.only(top: 5.0, bottom: 5.0, left: 5.0, right: 5.0),
        child: InkWell(
            onTap: () {
              Navigator.pushNamed(context, direccion);
            },
            child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 3.0,
                          blurRadius: 5.0)
                    ],
                    color: Colors.white),
                child: Column(children: [
                  SizedBox(height: 7.0),
                  Text(name,
                      style: TextStyle(
                          color: Color(0xFF575E67),
                          fontFamily: 'Varela',
                          fontSize: 14.0)),
                          ]))
                ));
  }
}