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
  int _cantidad;
  String _nombreProducto;
  double _precioC;
  double _precioV;

  final GlobalKey<FormState>_formKey = GlobalKey<FormState>();
  
  Widget _buildNombreProducto(){
    return TextFormField(
      initialValue: _nombreProducto,
      decoration: InputDecoration(labelText: 'Nombre de Producto'),
      style: TextStyle(fontSize: 28),
      validator: (String value) {
        if(value.isEmpty){
          return 'Ingresar nombre de producto';
        }
        return null;
      },
      onSaved: (String value){
        _nombreProducto = value;
      },
    );
  }

  Widget _buildPrecioC(){
    return TextFormField(
      initialValue: _precioC.toString(),
      decoration: InputDecoration(labelText: 'precio de compra'),
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: 28),
      validator: (String value){
        double precioC = double.tryParse(value);
        if(precioC == null || precioC <= 0){
          return 'Ingrese un precio de compra';
        }
        return null;
      },
      onSaved: (String value){
        _precioC = double.tryParse(value);
      },
    );
  }

  Widget _buildPrecioV(){
    return TextFormField(
      initialValue: _precioV.toString(),
      decoration: InputDecoration(labelText: 'precio de Venta'),
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: 28),
      validator: (String value){
        double precioV = double.tryParse(value);
        if(precioV == null || precioV <= 0){
          return 'Ingrese un precio de Venta';
        }
        return null;
      },
      onSaved: (String value){
        _precioV = double.tryParse(value);
      },
    );
  }

  Widget _buildCant(){
    return TextFormField(
      initialValue: _cantidad.toString(),
      decoration: InputDecoration(labelText: 'Cantidad de producto'),
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: 28),
      validator: (String value){
        double canti = double.tryParse(value);
        if(canti == null || canti <= 0){
          return 'Ingrese una cantidad';
        }
        return null;
      },
      onSaved: (String value){
        _cantidad = int.tryParse(value);
      },
    );
  }

  void crearProducto(Producto prod) async {
    if (_formKey.currentState.validate()){
      _formKey.currentState.save();
      await DBProvider.db.nuevoProducto(prod);
    }
  }

  @override
  void initState() { 
    super.initState();
    if (widget.producto != null){
      _cantidad = widget.producto.cant;
      _nombreProducto = widget.producto.nombreProducto;
      _precioC = widget.producto.precioC;
      _precioV = widget.producto.precioV;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Producto')),
      body: Container(
        margin: EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildNombreProducto(),
              _buildCant(),
              _buildPrecioC(),
              _buildPrecioV(),
              widget.producto == null
                  ? RaisedButton(
                    child: Text(
                      'Agregar',
                      style: TextStyle(color: Colors.blue),
                      ),
                    onPressed: (){
                      if(!_formKey.currentState.validate()){
                        return;
                      }
                      _formKey.currentState.save();
                      Producto pro = Producto(
                        cant: _cantidad,
                        nombreProducto: _nombreProducto,
                        precioC: _precioC,
                        precioV: _precioV,
                      );
                      crearProducto(pro);
                      Navigator.pop(context, true);
                      },
                    )
                  :Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        RaisedButton(
                          child: Text(
                            "Update",
                            style: TextStyle(color: Colors.blue, fontSize: 16),
                          ),
                          onPressed: null,
                        ),
                        RaisedButton(
                          child: Text(
                            "Cancel",
                            style: TextStyle(color: Colors.red, fontSize: 16),
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                  )
            ]
          ),
        )
      ),
    );
  }
}