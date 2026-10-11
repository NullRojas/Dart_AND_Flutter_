/// Clase que representa un Producto dentro del catálogo de la tienda.
///
/// Demuestra los conceptos fundamentales de Programación Orientada a Objetos (POO):
/// - Atributos finales con tipos explícitos ([String], [double]).
/// - Constructor con parámetros nombrados obligatorios (`required`).
/// - Métodos para dar formato e impresión.
class Producto {
  /// Nombre descriptivo del producto.
  final String nombre;

  /// Precio unitario del producto en pesos (COP).
  final double precio;

  /// Constructor de la clase [Producto].
  const Producto({
    required this.nombre,
    required this.precio,
  });

  /// Retorna el precio formateado con el símbolo de moneda.
  String obtenerPrecioFormateado() {
    return '\$${precio.toStringAsFixed(0)}';
  }

  @override
  String toString() {
    return '$nombre - ${obtenerPrecioFormateado()}';
  }
}
