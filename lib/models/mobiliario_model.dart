class MobiliarioModel {
  int? idMobiliario;
  String? nombreMobiliario;
  int? cantidadTotalMobiliario;
  int? cantidadDisponibleMobiliario;
  String? descripcionMobiliario;
  String? precioRentaMobiliario;
  MobiliarioModel(
      {this.idMobiliario,
      this.nombreMobiliario,
      this.cantidadTotalMobiliario,
      this.cantidadDisponibleMobiliario,
      this.descripcionMobiliario,
      this.precioRentaMobiliario});
}

class CategoriaModel {
  int? idCategoria;
  String? nombreCategoria;
  CategoriaModel({this.idCategoria, this.nombreCategoria});
}

class MobiliarioCategoriaModel {
  int? idMobiliario;
  int? idCategoria;
  MobiliarioCategoriaModel({this.idMobiliario, this.idCategoria});
}

class StatusModel {
  int? idStatus;
  String? nombreStatus;
  StatusModel({this.idStatus, this.nombreStatus});
}

class RentaModel {
  int? idRenta;
  String? fechaInicioRenta;
  String? fechaFinRenta;
  String? fechaEntregaRenta;
  String? nombreRenta;
  String? telefonoRenta;
  String? direccionRenta;
  String? montoRenta;
  RentaModel(
      {this.idRenta,
      this.fechaInicioRenta,
      this.fechaFinRenta,
      this.fechaEntregaRenta,
      this.nombreRenta,
      this.telefonoRenta,
      this.direccionRenta,
      this.montoRenta});
}

class RentaDetalleModel {
  int? idDetalle;
  int? idRenta;
  int? idMobiliario;
  int? cantidadDetalle;
  String? precioUnitarioDetalle;
  RentaDetalleModel(
      {this.idDetalle,
      this.idRenta,
      this.idMobiliario,
      this.cantidadDetalle,
      this.precioUnitarioDetalle});
}
