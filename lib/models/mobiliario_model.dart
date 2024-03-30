class MobiliarioModel {
  int? idMobiliario;
  String? nombreMobiliario;
  int? cantidadTotalMobiliario;
  int? cantidadDisponibleMobiliario;
  String? descripcionMobiliario;
  double? precioRentaMobiliario;
  MobiliarioModel(
      {this.idMobiliario,
      this.nombreMobiliario,
      this.cantidadTotalMobiliario,
      this.cantidadDisponibleMobiliario,
      this.descripcionMobiliario,
      this.precioRentaMobiliario});
  factory MobiliarioModel.fromMap(Map<String, dynamic> mobiliario) {
    return MobiliarioModel(
        idMobiliario: mobiliario['idMobiliario'],
        nombreMobiliario: mobiliario['nombreMobiliario'],
        cantidadTotalMobiliario: mobiliario['cantidadTotalMobiliario'],
        cantidadDisponibleMobiliario:
            mobiliario['cantidadDisponibleMobiliario'],
        descripcionMobiliario: mobiliario['descripcionMobiliario'],
        precioRentaMobiliario: mobiliario['precioRentaMobiliario']);
  }
}

class CategoriaModel {
  int? idCategoria;
  String? nombreCategoria;
  CategoriaModel({this.idCategoria, this.nombreCategoria});
  factory CategoriaModel.fromMap(Map<String, dynamic> categoria) {
    return CategoriaModel(
        idCategoria: categoria['idCategoria'],
        nombreCategoria: categoria['nombreCategoria']);
  }
}

class MobiliarioCategoriaModel {
  int? idMobiliario;
  int? idCategoria;
  MobiliarioCategoriaModel({this.idMobiliario, this.idCategoria});
  factory MobiliarioCategoriaModel.fromMap(Map<String, dynamic> mobcategoria) {
    return MobiliarioCategoriaModel(
        idMobiliario: mobcategoria['idMobiliario'],
        idCategoria: mobcategoria['idCategoria']);
  }
}

class StatusModel {
  int? idStatus;
  String? nombreStatus;
  StatusModel({this.idStatus, this.nombreStatus});
  factory StatusModel.fromMap(Map<String, dynamic> status) {
    return StatusModel(
        idStatus: status['idStatus'], nombreStatus: status['nombreStatus']);
  }
}

class RentaModel {
  int? idRenta;
  String? fechaInicioRenta;
  String? fechaFinRenta;
  String? fechaEntregaRenta;
  String? nombreRenta;
  String? telefonoRenta;
  String? direccionRenta;
  double? montoRenta;
  int? idStatus;
  RentaModel(
      {this.idRenta,
      this.fechaInicioRenta,
      this.fechaFinRenta,
      this.fechaEntregaRenta,
      this.nombreRenta,
      this.telefonoRenta,
      this.direccionRenta,
      this.montoRenta,
      this.idStatus});
  factory RentaModel.fromMap(Map<String, dynamic> renta) {
    return RentaModel(
        idRenta: renta['idRenta'],
        fechaInicioRenta: renta['fechaInicioRenta'],
        //Podria usar lo siguente despues:
        //fechaInicio: renta['fechaInicio'] != null ? DateTime.parse(renta['fechaInicio']) : null,
        fechaFinRenta: renta['fechaFinRenta'],
        fechaEntregaRenta: renta['fechaEntregaRenta'],
        nombreRenta: renta['nombreRenta'],
        telefonoRenta: renta['telefonoRenta'],
        direccionRenta: renta['direccionRenta'],
        montoRenta: renta['montoRenta'],
        idStatus: renta['idStatus']);
  }
}

class RentaDetalleModel {
  int? idRenta;
  int? idMobiliario;
  int? cantidadDetalle;
  double? precioUnitarioDetalle;
  RentaDetalleModel(
      {this.idRenta,
      this.idMobiliario,
      this.cantidadDetalle,
      this.precioUnitarioDetalle});
  factory RentaDetalleModel.fromMap(Map<String, dynamic> rendetalle) {
    return RentaDetalleModel(
        idRenta: rendetalle['idRenta'],
        idMobiliario: rendetalle['idMobiliario'],
        cantidadDetalle: rendetalle['cantidadDetalle'],
        precioUnitarioDetalle: rendetalle['precioUnitarioDetalle']);
  }
}
