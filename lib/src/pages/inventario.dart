import 'package:flutter/material.dart';
import 'package:inventario/src/database/database.dart';
import 'package:inventario/src/models/producto.dart';
import 'package:inventario/src/pages/agregarProducto.dart';
import 'package:sqflite/sqflite.dart';

class Inventario extends StatefulWidget {

  @override
  _InventarioState createState() => _InventarioState();
}

class _InventarioState extends State<Inventario> {
  final _formKey = GlobalKey<FormState>();
  Future<List<Producto>> future;

  final _biggerFont = const TextStyle(fontSize: 18.0); 
  List<Producto> proList;
	int count = 0;

  @override
  initState() {
    super.initState();
    future = DBProvider.db.getTodosProducto();
  }

  @override
  Widget build(BuildContext context) {
    if(proList == null){
      proList = List<Producto>();
      updateListView();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Inventario')
      ),
      body: ListView(
        padding: EdgeInsets.all(8),
        children: <Widget>[  
          Form(
            key: _formKey,
            child: _crearInput(),
          ),

          SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child:  DataTable(
            columns: <DataColumn>[
              DataColumn(
                label: Text("Cantidad"),
              ),
              DataColumn(
                label: Text("Nombre"),
              ),
              DataColumn(
                label: Text("Precio Compra"),
              ),
              DataColumn(
                label: Text("Precio Venta"),
              ),
              ],
              rows: proList
                  .map(
                    (name) => DataRow(
                          cells: [
                            DataCell(
                              Text(name.cant.toString()),
                              showEditIcon: false,
                              placeholder: false,
                            ),
                            DataCell(
                              Text(name.nombreProducto),
                              showEditIcon: false,
                              placeholder: false,
                            ),
                            DataCell(
                              Text(name.precioC.toString()),
                              showEditIcon: false,
                              placeholder: false,
                            ),
                            DataCell(
                              Text(name.precioV.toString()),
                              showEditIcon: false,
                              placeholder: false,
                            ),
                          ],
                        ),
                  )
                  .toList()),),)



        ],
      ),
   
      floatingActionButton: FloatingActionButton(
        onPressed: () {nuevoProducto();},
        tooltip: 'Agregar Nuevo Producto',
        child: Icon(Icons.add), 
      ),
    );
  }

  Card buildItem(Producto prodListado) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'nombre: ${prodListado.nombreProducto}',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 12),
          ],
        ),
      ),
    );
  }









  ListView getProListView(){
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position){
        return Card(
          color: Colors.white,
          child: ListTile(
            title: Text('Nombre: ' + this.proList[position].nombreProducto),
            subtitle: Text('Precio Compra:' + this.proList[position].precioC.toString()),
          ),
        );
      }
      );
  }

  void nuevoProducto() async {
    bool result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
		  return AgregarProducto();
	  }));

    if (result == true) {
	  	updateListView();
	  }
  }

  void updateListView(){
    final Future<Database> dbfuture = DBProvider.db.initDB();
    dbfuture.then((database) {
      Future<List<Producto>> pro = DBProvider.db.getTodosProducto();
      pro.then((proList){
        setState(() {
          this.proList = proList;
          this.count = proList.length;
        });
      });
    });
  }
  

  Widget _buildrow(Producto produc){
    return new ListTile(
      title: new Text(produc.nombreProducto),
    );
  }

  Widget _crearInput() {
    return TextField(
      // autofocus: true,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0)
        ),
        hintText: 'Nombre del producto',
        labelText: 'Nombre',
        suffixIcon: Icon( Icons.search)
      ),
      onChanged: null
      );
  }
}


