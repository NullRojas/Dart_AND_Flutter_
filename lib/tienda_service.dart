import 'producto.dart';

/// Servicio de lógica de negocio para la tienda.
///
/// Maneja el catálogo de productos, las validaciones con null safety,
/// y los cálculos de subtotal, descuento y total a pagar.
class TiendaService {
  /// Umbral monetario a partir del cual se aplica el descuento.
  /// La condición académica exige que el subtotal sea ESTRICTAMENTE SUPERIOR a $200.000.
  static const double umbralDescuento = 200000.0;

  /// Porcentaje de descuento aplicable (10%).
  static const double porcentajeDescuento = 0.10;

  /// Catálogo inicial con los 5 productos requeridos por la guía.
  final List<Producto> catalogo = const [
    Producto(nombre: 'Teclado', precio: 50000.0),
    Producto(nombre: 'Mouse', precio: 30000.0),
    Producto(nombre: 'Monitor', precio: 450000.0),
    Producto(nombre: 'Audífonos', precio: 80000.0),
    Producto(nombre: 'Memoria USB', precio: 25000.0),
  ];

  /// Imprime en consola el catálogo completo con numeración de 1 a N.
  void mostrarCatalogo() {
    print('=== CATÁLOGO DE PRODUCTOS ===');
    for (int i = 0; i < catalogo.length; i++) {
      final producto = catalogo[i];
      final numeroSeleccion = i + 1;
      print('$numeroSeleccion. ${producto.nombre} - ${producto.obtenerPrecioFormateado()}');
    }
  }

  /// Valida la opción ingresada por el usuario para elegir un producto.
  ///
  /// Retorna el índice (base 0) en la lista si es válida, o `null` si es inválida.
  /// Implementa Null Safety mediante [int.tryParse] para evitar excepciones.
  int? validarSeleccionProducto(String? entradaTexto) {
    if (entradaTexto == null || entradaTexto.trim().isEmpty) {
      return null;
    }

    final seleccion = int.tryParse(entradaTexto.trim());
    if (seleccion == null) {
      return null;
    }

    // Validar que el número esté dentro del rango disponible (1 a catalogo.length)
    if (seleccion < 1 || seleccion > catalogo.length) {
      return null;
    }

    // Convertir de opción (1..N) a índice base 0 de lista (0..N-1)
    return seleccion - 1;
  }

  /// Valida la cantidad de unidades solicitadas.
  ///
  /// Retorna la cantidad como [int] si es un entero mayor que cero, o `null` si no es válida.
  int? validarCantidad(String? entradaTexto) {
    if (entradaTexto == null || entradaTexto.trim().isEmpty) {
      return null;
    }

    final cantidad = int.tryParse(entradaTexto.trim());
    if (cantidad == null || cantidad <= 0) {
      return null;
    }

    return cantidad;
  }

  /// Calcula el subtotal de la compra.
  ///
  /// Fórmula: subtotal = precio unitario × cantidad
  double calcularSubtotal(double precioUnitario, int cantidad) {
    return precioUnitario * cantidad;
  }

  /// Calcula el descuento aplicando un 10% únicamente cuando el subtotal es > $200.000.
  ///
  /// Fórmula: descuento = subtotal × 0.10 si subtotal > 200000.0, caso contrario $0.
  double calcularDescuento(double subtotal) {
    if (subtotal > umbralDescuento) {
      return subtotal * porcentajeDescuento;
    }
    return 0.0;
  }

  /// Calcula el total a pagar restando el descuento del subtotal.
  ///
  /// Fórmula: total = subtotal - descuento
  double calcularTotal(double subtotal, double descuento) {
    return subtotal - descuento;
  }

  /// Genera una representación textual formateada con el resumen final de la compra.
  String generarResumenCompra({
    required Producto producto,
    required int cantidad,
    required double subtotal,
    required double descuento,
    required double total,
  }) {
    final buffer = StringBuffer();
    buffer.writeln('===================================');
    buffer.writeln('        RESUMEN DE COMPRA          ');
    buffer.writeln('===================================');
    buffer.writeln('Producto seleccionado : ${producto.nombre}');
    buffer.writeln('Precio unitario       : ${producto.obtenerPrecioFormateado()}');
    buffer.writeln('Cantidad              : $cantidad unidad(es)');
    buffer.writeln('-----------------------------------');
    buffer.writeln('Subtotal              : \$${subtotal.toStringAsFixed(0)}');
    if (descuento > 0) {
      buffer.writeln('Descuento aplicado (10%) : -\$${descuento.toStringAsFixed(0)}');
    } else {
      buffer.writeln('Descuento aplicado    : \$0 (No aplica)');
    }
    buffer.writeln('-----------------------------------');
    buffer.writeln('TOTAL A PAGAR         : \$${total.toStringAsFixed(0)}');
    buffer.writeln('===================================');
    return buffer.toString();
  }
}
