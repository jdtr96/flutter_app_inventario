import 'package:flutter/material.dart';
import 'package:inventario/src/database/database.dart';
import 'package:inventario/src/models/producto.dart';

class AgregarProducto extends StatefulWidget {
  final Producto producto;
  
  AgregarProducto({this.producto});

  @override
  _AgregarProductoState createState() => _AgregarProductoState();
}

class _AgregarProductoState extends State<AgregarProducto> {
  int _id;
  String _cantidad;
  String _nombreProducto;
  String _precioC;
  String _precioV;

  final GlobalKey<FormState>_formKey = GlobalKey<FormState>();
  
  Widget _buildNombreProducto(){
    return TextFormField(
      initialValue: _nombreProducto,
      decoration: InputDecoration(
        labelText: 'Nombre de Producto',
        suffixIcon: Icon(Icons.assignment, size: 40.0,),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0)
        ),
      ),
      style: TextStyle(fontSize: 20),
      validator: (String value) {
        if(value.isEmpty){
          return 'Ingresar nombre del producto';
        }
        return null;
      },
      onSaved: (String value){
        _nombreProducto = value;
      },
    );
  }

  Widget _buildCant(){
    return TextFormField(
      initialValue: _cantidad.toString(),
      decoration: InputDecoration(
        labelText: 'Cantidad de producto',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0)
        )
      ),
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: 20),
      validator: (String value) {
        if(value.isEmpty){
          return 'Ingresar cantidad de producto';
        }
        return null;
      },
      onSaved: (String value){
        _cantidad = value;
      },
    );
  }

  Widget _buildPrecioC(){
    return TextFormField(
      initialValue: _precioC.toString(),
      decoration: InputDecoration(
        labelText: 'Precio de compra',
        suffixIcon: Icon(Icons.monetization_on, size: 40.0,),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0)
        ),
      ),
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: 20.0),
      validator: (String value) {
        if(value.isEmpty){
          return 'Ingresar precio de compra';
        }
        return null;
      },
      onSaved: (String value){
        _precioC = value;
      },
    );
  }

  Widget _buildPrecioV(){
    return TextFormField(
      initialValue: _precioV.toString(),
      decoration: InputDecoration(
        labelText: 'Precio de Venta',
        suffixIcon: Icon(Icons.monetization_on, size: 40.0,),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0)
        ),
      ),
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: 20.0),
      validator: (String value) {
        if(value.isEmpty){
          return 'Ingresar precio de venta';
        }
        return null;
      },
      onSaved: (String value){
        _precioV = value;
      },
    );
  }

  obtenerid() async{
    Producto p = await DBProvider.db.obtenerID();
    if(p.id == null){
      _id = p.id;
    }
    else{
      _id = p.id + 1;
    }
  }

  void crearProducto(Producto prod) async {
    if (_formKey.currentState.validate()){
      _formKey.currentState.save();
      await DBProvider.db.nuevoProducto(prod);
    }
  }

  void updateProducto(Producto prod) async {
    if (_formKey.currentState.validate()){
      _formKey.currentState.save();
      await DBProvider.db.updateProducto(prod);
    }
  }

  @override
  void initState() { 
    super.initState();
    if (widget.producto != null){
      _id = widget.producto.id;
      _cantidad = widget.producto.cant.toString();
      _nombreProducto = widget.producto.nombreProducto;
      _precioC = widget.producto.precioC.toString();
      _precioV = widget.producto.precioV.toString();
    }
    else{
      _cantidad = "";
      _nombreProducto = "";
      _precioC = "";
      _precioV = "";
      obtenerid();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Producto')),
      body: Container(
        margin: EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _buildNombreProducto(),
                SizedBox(height:20.0),
                _buildCant(),
                SizedBox(height:20.0),
                _buildPrecioC(),
                SizedBox(height:20.0),
                _buildPrecioV(),
                SizedBox(height:35.0),
                widget.producto == null
                    ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        RaisedButton(
                          child: Text(
                            'AGREGAR',
                            style: TextStyle(color: Colors.white, fontSize: 25.0),
                            ),
                          color: Colors.blueAccent,
                          padding: EdgeInsets.all(15.0),
                          onPressed: (){
                            if(_formKey.currentState.validate()){
                              _formKey.currentState.save();
                              Producto pro = Producto(
                                id: _id,
                                cant: int.parse(_cantidad),
                                nombreProducto: _nombreProducto,
                                precioC: double.parse(_precioC),
                                precioV: double.parse(_precioV),
                              );
                              crearProducto(pro);
                              Navigator.pop(context, true);
                          }
                        },
                      ),
                      RaisedButton(
                            child: Text(
                              "CANCELAR",
                              style: TextStyle(color: Colors.white, fontSize: 25.0),
                            ),
                            color: Colors.red,
                            padding: EdgeInsets.all(15.0),
                            onPressed: () => Navigator.pop(context),
                          ),
                      ],
                    )
                    :Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          RaisedButton(
                            child: Text(
                              "ACTUALIZAR",
                              style: TextStyle(color: Colors.blue, fontSize: 16),
                            ),
                            onPressed: (){                            
                              if(_formKey.currentState.validate()){
                                _formKey.currentState.save();
                                Producto pro = Producto(
                                  id: _id,
                                  cant: int.parse(_cantidad),
                                  nombreProducto: _nombreProducto,
                                  precioC: double.parse(_precioC),
                                  precioV: double.parse(_precioV),
                                );
                                updateProducto(pro);
                                Navigator.pop(context, true);
                              }
                            }
                          ),
                          RaisedButton(
                            child: Text(
                              "CANCELAR",
                              style: TextStyle(color: Colors.red, fontSize: 16),
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                    )
              ]
            ),
          ),
        )
      ),
    );
  }
}