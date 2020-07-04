import 'dart:io';
import 'package:inventario/src/models/compraventa.dart';
import 'package:inventario/src/models/producto.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class DBProvider{
  static Database _database;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database> get database async {
    if( _database != null ) return _database;

    _database = await initDB();
    return _database;
  }

  Future<Database> initDB() async {
    var tablas = new List(2);
    tablas[0] = "CREATE TABLE Producto (id INTEGER PRIMARY KEY, cant INTEGER, nombreProducto TEXT, precioC FLOAT, precioV float)";
    tablas[1] = "CREATE TABLE compraVenta (id INTEGER PRIMARY KEY, fecha TEXT, cantidad INTEGER, iDproducto INTEGER, compra BOOL)";

    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'InventarioDB.db');
    return await openDatabase(
      path,
      version: 1,
      onOpen: (db) {},
      onCreate: ( Database db, int version) async {
        for (var tabla in tablas){
          await db.execute(tabla);
        }
      }      
    );
  }

  obtenerID() async {
    final db = await database;
    final res = await db.rawQuery("SELECT MAX(id) FROM Producto");
    return res.isNotEmpty ? Producto.fromJsonID(res.first) : [];
  }

  nuevoProducto( Producto nuevoProducto ) async {
    final db = await database;
    final res = await db.insert('Producto', nuevoProducto.toJson() ); 
    return res;
  }

  Future<List<Producto>> getTodosProducto() async {
    final db = await database;
    final res = await db.query('Producto');
    List<Producto> list = res.isNotEmpty ? res.map((c) => Producto.fromJson(c)).toList() : [];
    return list;
  }

  Future<List<Producto>> getProductoNombre( String nombre) async {
    final db = await database;
    final res = await db.rawQuery("SELECT * FROM Producto WHERE nombreProducto LIKE '%$nombre%'");
    List<Producto> list = res.isNotEmpty ? res.map((c) => Producto.fromJson(c)).toList() : [];
    return list;
  }

  Future<int> updateProducto( Producto updateproducto) async {
    final db = await database;
    final res = await db.update('Producto', updateproducto.toJson(), where: 'id = ?', whereArgs: [updateproducto.id]);
    return res;
  }

  Future<int> deleteProducto(int id) async {
    final db = await database;
    final res = await db.delete('Producto', where: 'id = ?', whereArgs: [id]);
    return int.tryParse(res.toString());
  }

  nuevoCompraVenta(CompraVenta compraventa) async {
    final db = await database;
    final res = await db.insert('compraVenta', compraventa.toJson() ); 
    return res;
  }

  Future<List<CompraVenta>> getTodosCompra() async {
    final db = await database;
    final res = await db.query('compraVenta', where: "compra = 1");
    List<CompraVenta> list = res.isNotEmpty ? res.map((c) => CompraVenta.fromJson(c)).toList() : [];
    return list;
  }

  Future<List<Producto>> getProductoCompraFecha( String fecha) async {
    final db = await database;
    final res = await db.rawQuery("SELECT * FROM compraVenta WHERE fecha = '$fecha' and compra = 1");
    List<Producto> list = res.isNotEmpty ? res.map((c) => Producto.fromJson(c)).toList() : [];
    return list;
  }

  Future<List<CompraVenta>> getTodosVenta() async {
    final db = await database;
    final res = await db.query('compraVenta', where: "compra = 0");
    List<CompraVenta> list = res.isNotEmpty ? res.map((c) => CompraVenta.fromJson(c)).toList() : [];
    return list;
  }

  Future<List<Producto>> getProductoVentaFecha( String fecha) async {
    final db = await database;
    final res = await db.rawQuery("SELECT * FROM compraVenta WHERE fecha = '$fecha' and compra = 0");
    List<Producto> list = res.isNotEmpty ? res.map((c) => Producto.fromJson(c)).toList() : [];
    return list;
  }
  
}