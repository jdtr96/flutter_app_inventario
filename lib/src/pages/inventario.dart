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
  List<Producto> proList;
	int count = 0;

  @override
  initState() {
    super.initState();
    this.proList = [];
    this.count = 0;
    updateListView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inventario')
      ),
      body: ListView(
        padding: EdgeInsets.all(5),
        children: <Widget>[
          SizedBox(height:20.0),
          Form(
            key: _formKey,
            child: _crearInput(),
          ),
          SizedBox(height:15.0),
          SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child:  DataTable(
                    columns: <DataColumn>[
                      DataColumn(
                        label: Text("Cantidad",style: TextStyle(color: Colors.black, fontSize: 20.0),),
                      ),
                      DataColumn(
                        label: Text("Nombre",style: TextStyle(color: Colors.black, fontSize: 20.0),),
                      ),
                      DataColumn(
                        label: Text("Borrar",style: TextStyle(color: Colors.black, fontSize: 20.0),),
                      ),
                      ],
                      rows: proList
                          .map(
                            (name) => DataRow(
                                  cells: [
                                    DataCell(
                                      Text(name.cant.toString(), style: TextStyle(color: Colors.black, fontSize: 15.0),),
                                      showEditIcon: false,
                                      placeholder: false,
                                      onTap: () => showProducDialog(context, name),
                                    ),
                                    DataCell(
                                      Text(name.nombreProducto, style: TextStyle(color: Colors.black, fontSize: 15.0),),
                                      showEditIcon: false,
                                      placeholder: false,
                                      onTap: () => showProducDialog(context, name),
                                    ),
                                    DataCell( new IconButton(
                                      icon: const Icon(Icons.delete_forever,
                                        color: const Color(0xFF167F67),), 
                                      onPressed: () => showProducBorrarDialog(context, name),
                                      alignment: Alignment.centerLeft
                                      ),
                                    )
                                  ],
                                ),
                              ).toList()
                            ),
                          ),
                        )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {nuevoProducto();},
        tooltip: 'Agregar Nuevo Producto',
        child: Icon(Icons.add), 
      ),
    );
  }

  showProducDialog(BuildContext context, Producto produ){
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(produ.nombreProducto),
        content: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('Precio Compra:    '+ produ.precioC.toString()),
              Text('Precio Venta:        '+ produ.precioV.toString())
            ]
          )
          ),
        actions: <Widget>[
          FlatButton(
            onPressed: () {actualizarProducto(produ);},
            child: Text('Actualizar')
          ),
          FlatButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancelar"),
          ),
        ],
      ),
    );
  }

  showProducBorrarDialog(BuildContext context, Producto produ){
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Desea Borrar'),
        content: Text(produ.nombreProducto),
        actions: <Widget>[
          FlatButton(
            onPressed: () {borrarProducto(produ.id); Navigator.pop(context);},
            child: Text('Borrar')
          ),
          FlatButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancelar"),
          ),
        ],
      ),
    );
  }

  void borrarProducto(int id) async {
    int res = await DBProvider.db.deleteProducto(id);
    if(res == 1){
      updateListView();
    }
  }

  void actualizarProducto(Producto p) async {
    bool result = await Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
		  return AgregarProducto(producto: p,);
	  }));
    if (result == true) {
	  	updateListView();
	  }
  }

  void nuevoProducto() async {
    bool result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
		  return AgregarProducto();
	  }));
    if (result == true) {
	  	updateListView();
	  }
  }

  void listarProduNom(String nombre){
    if(nombre.isEmpty){
      updateListView();
    }
    else{
      final Future<Database> dbfuture = DBProvider.db.initDB();
      dbfuture.then((database) {
      Future<List<Producto>> pro = DBProvider.db.getProductoNombre(nombre);
      pro.then((proList){
        setState(() {
          this.proList = proList;
          this.count = proList.length;
        });
      });
    });
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

  Widget _crearInput() {
    return TextField(
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0)
        ),
        hintText: 'Nombre del producto',
        labelText: 'Nombre',
        suffixIcon: Icon( Icons.search)
      ),
      onChanged: (text) {
        listarProduNom(text);
      },
    );
  }
}


