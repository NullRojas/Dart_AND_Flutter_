import 'dart:io';
import '../lib/producto.dart';
import '../lib/tienda_service.dart';

/// Punto de entrada del programa de consola en Dart.
void main() {
  final tienda = TiendaService();

  print('\n-----------------------------------------------');
  print('  BIENVENIDO AL SISTEMA DE GESTIÓN DE COMPRAS');
  print('-----------------------------------------------\n');

  // 1. Mostrar catálogo
  tienda.mostrarCatalogo();
  print('');

  // 2. Selección de producto con validación
  Producto? productoSeleccionado;
  while (productoSeleccionado == null) {
    stdout.write('Ingrese el número del producto a comprar (1-${tienda.catalogo.length}): ');
    final entradaProducto = stdin.readLineSync();

    final indiceValido = tienda.validarSeleccionProducto(entradaProducto);
    if (indiceValido != null) {
      productoSeleccionado = tienda.catalogo[indiceValido];
    } else {
      print('❌ ERROR: Selección inválida. Ingrese un número entre 1 y ${tienda.catalogo.length}.\n');
    }
  }

  print('✔ Producto seleccionado: ${productoSeleccionado.nombre} (${productoSeleccionado.obtenerPrecioFormateado()})\n');

  // 3. Selección de cantidad con validación
  int? cantidadValida;
  while (cantidadValida == null) {
    stdout.write('Ingrese la cantidad de unidades que desea comprar: ');
    final entradaCantidad = stdin.readLineSync();

    cantidadValida = tienda.validarCantidad(entradaCantidad);
    if (cantidadValida == null) {
      print('❌ ERROR: Cantidad inválida. Debe ingresar un número entero mayor a cero (ejemplo: 1, 2, 5).\n');
    }
  }

  print('✔ Cantidad ingresada: $cantidadValida unidad(es)\n');

  // 4. Cálculo de subtotal, descuento y total
  final double subtotal = tienda.calcularSubtotal(productoSeleccionado.precio, cantidadValida);
  final double descuento = tienda.calcularDescuento(subtotal);
  final double total = tienda.calcularTotal(subtotal, descuento);

  // 5. Presentación del resumen de la compra
  final resumen = tienda.generarResumenCompra(
    producto: productoSeleccionado,
    cantidad: cantidadValida,
    subtotal: subtotal,
    descuento: descuento,
    total: total,
  );

  print(resumen);
  print('¡Gracias por su compra!\n');
}
