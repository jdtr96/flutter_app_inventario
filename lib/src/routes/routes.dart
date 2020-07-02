import 'package:flutter/material.dart';
import 'package:inventario/src/pages/agregarProducto.dart';

import 'package:inventario/src/pages/inventario_home.dart';
import 'package:inventario/src/pages/inventario.dart';

Map<String, WidgetBuilder> getApplicationRoutes(){
  return <String, WidgetBuilder>{
    '/' : (BuildContext context) => Inventario_home(),
    'invent' : (BuildContext context) => Inventario(),
    'agregarProducto': (BuildContext context) => AgregarProducto()
  };
}