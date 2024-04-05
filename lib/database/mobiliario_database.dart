import 'dart:io';
import 'package:renta_movil_app/models/mobiliario_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class MobiliarioDatabase {
  static const NAMEDB = 'MobiliarioBD';
  static const VERSIONDB = 1;
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    return _database = await _initDatabase();
  }

  Future<Database> _initDatabase() async {
    Directory folder = await getApplicationDocumentsDirectory();
    String pathDB = join(folder.path, NAMEDB);
    return openDatabase(
      pathDB,
      version: VERSIONDB,
      onCreate: (db, version) {
        String queryMobiliario = '''CREATE TABLE Mobiliario(
          idMobiliario INTEGER PRIMARY KEY,
          nombreMobiliario TEXT,
          cantidadTotalMobiliario INTEGER,
          cantidadDisponibleMobiliario INTEGER,
          descripcionMobiliario TEXT,
          precioRentaMobiliario REAL
        ) ''';
        db.execute(queryMobiliario);
        String queryCategoria = '''CREATE TABLE Categoria(
          idCategoria INTEGER PRIMARY KEY,
          nombreCategoria TEXT
        )''';
        db.execute(queryCategoria);
        String queryMobiliarioCategoria = '''CREATE TABLE MobiliarioCategoria(
          idMobiliario INTEGER,
          idCategoria INTEGER,
          PRIMARY KEY (idMobiliario, idCategoria),
          FOREIGN KEY (idMobiliario) REFERENCES Mobiliario(idMobiliario),
          FOREIGN KEY (idCategoria) REFERENCES Categoria(idCategoria)
        )''';
        db.execute(queryMobiliarioCategoria);
        String queryStatus = '''CREATE TABLE Status(
          idStatus INTEGER PRIMARY KEY,
          nombreStatus TEXT
        )''';
        db.execute(queryStatus);
        String queryRenta = '''CREATE TABLE Renta(
          idRenta INTEGER PRIMARY KEY,
          idStatus INTEGER,
          fechaInicioRenta TEXT,
          fechaFinRenta TEXT,
          fechaEntregaRenta TEXT,
          nombreRenta TEXT,
          telefonoRenta TEXT,
          direccionRenta TEXT,
          montoRenta REAL,
          FOREIGN KEY (idStatus) REFERENCES Status(idStatus)
        )''';
        db.execute(queryRenta);
        String queryRentaDetalle = '''CREATE TABLE RentaDetalle(
          idRenta INTEGER,
          idMobiliario INTEGER,
          cantidadDetalle INTEGER,
          precioUnitarioDetalle REAL,
          PRIMARY KEY (idRenta, idMobiliario),
          FOREIGN KEY (idRenta) REFERENCES Renta(idRenta),
          FOREIGN KEY (idMobiliario) REFERENCES Mobiliario(idMobiliario)
        )''';
        db.execute(queryRentaDetalle);
      },
      onConfigure: (db) {
        db.execute('PRAGMA foreign_keys = ON');
      },
    );
  }

  //CRUD Mobiliario
  Future<int> insertarMobiliario(Map<String, dynamic> data) async {
    var conexion = await database;
    return conexion.insert('Mobiliario', data);
  }

  Future<int> actualizarMobiliario(Map<String, dynamic> data) async {
    var conexion = await database;
    return conexion.update('Mobiliario', data,
        where: 'idMobiliario=?', whereArgs: [data['idMobiliario']]);
  }

  Future<int> eliminarMobiliario(int id) async {
    var conexion = await database;
    return conexion
        .delete('Mobiliario', where: 'idMobiliario=?', whereArgs: [id]);
  }

  Future<List<MobiliarioModel>> consultarMobiliario() async {
    var conexion = await database;
    var mobiliarios = await conexion.query('Mobiliario');
    return mobiliarios
        .map((mobiliario) => MobiliarioModel.fromMap(mobiliario))
        .toList();
  }

  //CRUD Categoria
  Future<int> insertarCategoria(Map<String, dynamic> data) async {
    var conexion = await database;
    return conexion.insert('Categoria', data);
  }

  Future<int> actualizarCategoria(Map<String, dynamic> data) async {
    var conexion = await database;
    return conexion.update('Categoria', data,
        where: 'idCategoria=?', whereArgs: [data['idCategoria']]);
  }

  Future<int> eliminarCategoria(int id) async {
    var conexion = await database;
    return conexion
        .delete('Categoria', where: 'idCategoria=?', whereArgs: [id]);
  }

  Future<List<CategoriaModel>> consultarCategoria() async {
    var conexion = await database;
    var categorias = await conexion.query('Categoria');
    return categorias
        .map((categoria) => CategoriaModel.fromMap(categoria))
        .toList();
  }

  //CRUD Status
  Future<int> insertarStatus(Map<String, dynamic> data) async {
    var conexion = await database;
    return conexion.insert('Status', data);
  }

  Future<int> actualizarStatus(Map<String, dynamic> data) async {
    var conexion = await database;
    return conexion.update('Status', data,
        where: 'idStatus=?', whereArgs: [data['idStatus']]);
  }

  Future<int> eliminarStatus(int id) async {
    var conexion = await database;
    return conexion.delete('Status', where: 'idStatus=?', whereArgs: [id]);
  }

  Future<List<StatusModel>> consultarStatus() async {
    var conexion = await database;
    var statuses = await conexion.query('Status');
    return statuses.map((status) => StatusModel.fromMap(status)).toList();
  }

  //CRUD Renta
  Future<int> insertarRenta(Map<String, dynamic> data) async {
    var conexion = await database;
    return conexion.insert('Renta', data);
  }

  Future<int> actualizarRenta(Map<String, dynamic> data) async {
    var conexion = await database;
    print("ESTO ES DATA: $data");
    return conexion.update('Renta', data,
        where: 'idRenta=?', whereArgs: [data['idRenta']]);
  }

  Future<int> eliminarRenta(int id) async {
    var conexion = await database;
    return conexion.delete('Renta', where: 'idRenta=?', whereArgs: [id]);
  }

  Future<List<RentaModel>> consultarRenta() async {
    var conexion = await database;
    var rentas = await conexion.query('Renta');
    return rentas.map((renta) => RentaModel.fromMap(renta)).toList();
  }

  //Esta consulta es util para mostrar tambien el nombre del status
  Future<List<Map<String, dynamic>>> consultarRentaConStatus() async {
    var conexion = await database;
    var rentas = await conexion.rawQuery('''
    SELECT Renta.idRenta, Renta.idStatus, Status.nombreStatus AS statusNombre, Renta.fechaInicioRenta, Renta.fechaFinRenta,
          Renta.fechaEntregaRenta, Renta.nombreRenta, Renta.telefonoRente, Renta.direccionRenta, Renta.montoRenta
    FROM Renta
    JOIN Status ON Renta.idStatus = Status.idStatus
  ''');
    return rentas;
  }

  //CRUD MobiliarioCategoria
  Future<int> insertarMobiliarioCategoria(Map<String, dynamic> data) async {
    var conexion = await database;
    return conexion.insert('MobiliarioCategoria', data);
  }

  /*Alternativamente 
  Future<int> insertarMobiliarioCategoria(int idMobiliario, int idCategoria) async {
  var conexion = await database;
  return conexion.insert('MobiliarioCategoria', {
    'idMobiliario': idMobiliario,
    'idCategoria': idCategoria,
  });
}
  */
  Future<int> eliminarMobiliarioCategoria(Map<String, dynamic> data) async {
    var conexion = await database;
    return conexion.delete('MobiliarioCategoria',
        where: 'idMobiliario = ? AND idCategoria = ?',
        whereArgs: [data['idMobiliario'], data['idCategoria']]);
  }

  Future<List<MobiliarioCategoriaModel>> consultarMobiliarioCategoria() async {
    var conexion = await database;
    var mobCategorias = await conexion.query('MobiliarioCategoria');
    return mobCategorias
        .map((mobCategoria) => MobiliarioCategoriaModel.fromMap(mobCategoria))
        .toList();
  }

  Future<int> actualizarMobiliarioCategoria(
      Map<String, dynamic> data, Map<String, dynamic> nuevoData) async {
    int filasAfectadas = 0;
    // Primero, eliminamos la relación existente
    int filasEliminadas = await eliminarMobiliarioCategoria(data);
    filasAfectadas += filasEliminadas;
    // Luego, insertamos la nueva relación
    int filasInsertadas = await insertarMobiliarioCategoria(nuevoData);
    filasAfectadas += filasInsertadas;
    // Devolvemos el total de filas afectadas
    return filasAfectadas;
  }

  //CRUD RentaDetalle
  Future<int> insertarRentaDetalle(Map<String, dynamic> data) async {
    var conexion = await database;
    return conexion.insert('RentaDetalle', data);
  }

  Future<int> eliminarRentaDetalle(Map<String, dynamic> data) async {
    var conexion = await database;
    return conexion.delete('RentaDetalle',
        where: 'idRenta = ? AND idMobiliario= ?',
        whereArgs: [data['idRenta'], data['idMobiliario']]);
  }

  Future<List<RentaDetalleModel>> consultarRentaDetalle() async {
    var conexion = await database;
    var renDetalles = await conexion.query('RentaDetalle');
    return renDetalles
        .map((renDetalle) => RentaDetalleModel.fromMap(renDetalle))
        .toList();
  }

  Future<int> actualizaRentaDetalle(
      Map<String, dynamic> data, Map<String, dynamic> nuevoData) async {
    int filasAfectadas = 0;
    int filasEliminadas = await eliminarRentaDetalle(data);
    filasAfectadas += filasEliminadas;
    int filasInsertadas = await insertarRentaDetalle(nuevoData);
    filasAfectadas += filasInsertadas;
    return filasAfectadas;
  }
}
