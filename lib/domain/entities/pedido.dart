class Pedido {
  final int idDetalle;
  final int idVenta;
  final String? nombreServicio;
  final String? descripcion;
  final int idEstado;
  final String estado;
  final double precio;

  const Pedido({
    required this.idDetalle,
    required this.idVenta,
    this.nombreServicio,
    this.descripcion,
    required this.idEstado,
    required this.estado,
    required this.precio,
  });
}
