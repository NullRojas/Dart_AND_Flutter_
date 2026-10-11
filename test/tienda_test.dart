import 'package:test/test.dart';
import '../lib/producto.dart';
import '../lib/tienda_service.dart';

void main() {
  late TiendaService tienda;

  setUp(() {
    tienda = TiendaService();
  });

  group('Pruebas de Catálogo y Modelo Producto', () {
    test('El catálogo debe contener al menos 5 productos', () {
      expect(tienda.catalogo.length, greaterThanOrEqualTo(5));
    });

    test('Verificación de atributos del primer producto', () {
      final p1 = tienda.catalogo[0];
      expect(p1.nombre, equals('Teclado'));
      expect(p1.precio, equals(50000.0));
      expect(p1.obtenerPrecioFormateado(), equals('\$50000'));
    });
  });

  group('Pruebas Obligatorias de Casos de Uso (Tabla del laboratorio)', () {
    test('Caso 1: Producto 1 (Teclado $50.000), cantidad 5 -> Subtotal $250.000, Descuento $25.000, Total $225.000', () {
      final producto = tienda.catalogo[0]; // Teclado $50.000
      final int cantidad = 5;

      final subtotal = tienda.calcularSubtotal(producto.precio, cantidad);
      final descuento = tienda.calcularDescuento(subtotal);
      final total = tienda.calcularTotal(subtotal, descuento);

      expect(subtotal, equals(250000.0));
      expect(descuento, equals(25000.0));
      expect(total, equals(225000.0));
    });

    test('Caso 2: Producto 3 (Monitor $450.000), cantidad 1 -> Subtotal $450.000, Descuento $45.000, Total $405.000', () {
      final producto = tienda.catalogo[2]; // Monitor $450.000
      final int cantidad = 1;

      final subtotal = tienda.calcularSubtotal(producto.precio, cantidad);
      final descuento = tienda.calcularDescuento(subtotal);
      final total = tienda.calcularTotal(subtotal, descuento);

      expect(subtotal, equals(450000.0));
      expect(descuento, equals(45000.0));
      expect(total, equals(405000.0));
    });

    test('Caso 3: Producto 2 (Mouse $30.000), cantidad 1 -> Subtotal $30.000, Descuento $0, Total $30.000', () {
      final producto = tienda.catalogo[1]; // Mouse $30.000
      final int cantidad = 1;

      final subtotal = tienda.calcularSubtotal(producto.precio, cantidad);
      final descuento = tienda.calcularDescuento(subtotal);
      final total = tienda.calcularTotal(subtotal, descuento);

      expect(subtotal, equals(30000.0));
      expect(descuento, equals(0.0));
      expect(total, equals(30000.0));
    });

    test('Caso 4: Subtotal exactamente $200.000 -> Descuento $0 (La regla exige estrictamente superior a $200.000)', () {
      const double subtotalExacto = 200000.0;

      final descuento = tienda.calcularDescuento(subtotalExacto);
      final total = tienda.calcularTotal(subtotalExacto, descuento);

      expect(descuento, equals(0.0));
      expect(total, equals(200000.0));
    });

    test('Caso 5: Selección de producto fuera de rango (ejemplo: 9) -> Retorna null (Inválida)', () {
      expect(tienda.validarSeleccionProducto('9'), isNull);
      expect(tienda.validarSeleccionProducto('0'), isNull);
      expect(tienda.validarSeleccionProducto('-1'), isNull);
    });

    test('Caso 6: Cantidad igual a 0 -> Retorna null (Inválida)', () {
      expect(tienda.validarCantidad('0'), isNull);
    });

    test('Caso 7: Cantidad negativa -> Retorna null (Inválida)', () {
      expect(tienda.validarCantidad('-5'), isNull);
    });

    test('Caso 8: Entrada de cantidad con letras (ejemplo: "abc") -> Retorna null sin fallar', () {
      expect(tienda.validarCantidad('abc'), isNull);
      expect(tienda.validarCantidad('12.5'), isNull);
    });

    test('Caso 9: Entrada vacía o nula -> Retorna null', () {
      expect(tienda.validarSeleccionProducto(''), isNull);
      expect(tienda.validarSeleccionProducto(null), isNull);
      expect(tienda.validarCantidad(''), isNull);
      expect(tienda.validarCantidad(null), isNull);
    });
  });
}
