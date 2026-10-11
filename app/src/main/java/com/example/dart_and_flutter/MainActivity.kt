package com.example.dart_and_flutter

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.example.dart_and_flutter.ui.theme.Dart_AND_FlutterTheme

data class ProductoItem(
    val id: Int,
    val nombre: String,
    val precio: Double
) {
    fun precioFormateado(): String = "\$${precio.toInt()}"
}

data class ResumenData(
    val productoNombre: String,
    val precioUnitario: String,
    val cantidad: Int,
    val subtotal: Double,
    val descuento: Double,
    val total: Double
)

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContent {
            Dart_AND_FlutterTheme {
                Scaffold(modifier = Modifier.fillMaxSize()) { innerPadding ->
                    TiendaScreen(modifier = Modifier.padding(innerPadding))
                }
            }
        }
    }
}

@Composable
fun TiendaScreen(modifier: Modifier = Modifier) {
    val catalogo = remember {
        listOf(
            ProductoItem(1, "Teclado", 50000.0),
            ProductoItem(2, "Mouse", 30000.0),
            ProductoItem(3, "Monitor", 450000.0),
            ProductoItem(4, "Audífonos", 80000.0),
            ProductoItem(5, "Memoria USB", 25000.0)
        )
    }

    var numeroProductoTexto by remember { mutableStateOf("") }
    var cantidadTexto by remember { mutableStateOf("") }
    var mensajeError by remember { mutableStateOf<String?>(null) }
    var resumenCompra by remember { mutableStateOf<ResumenData?>(null) }

    val umbralDescuento = 200000.0
    val porcentajeDescuento = 0.10

    // Determinar producto seleccionado según el texto de número o clic
    val idIngresado = numeroProductoTexto.toIntOrNull()
    val productoSeleccionado = catalogo.find { it.id == idIngresado }

    Column(
        modifier = modifier
            .fillMaxSize()
            .verticalScroll(rememberScrollState())
            .padding(16.dp)
    ) {
        Text(
            text = "=== CATÁLOGO DE PRODUCTOS ===",
            fontSize = 18.sp,
            fontWeight = FontWeight.Bold,
            modifier = Modifier.padding(bottom = 8.dp)
        )

        Card(
            modifier = Modifier.fillMaxWidth(),
            elevation = CardDefaults.cardElevation(defaultElevation = 2.dp)
        ) {
            Column(modifier = Modifier.padding(8.dp)) {
                catalogo.forEach { producto ->
                    val esSeleccionado = productoSeleccionado == producto
                    Row(
                        modifier = Modifier
                            .fillMaxWidth()
                            .clickable {
                                numeroProductoTexto = producto.id.toString()
                                mensajeError = null
                                resumenCompra = null
                            }
                            .padding(vertical = 10.dp, horizontal = 8.dp),
                        horizontalArrangement = Arrangement.SpaceBetween
                    ) {
                        Text(
                            text = "${producto.id}. ${producto.nombre}",
                            fontWeight = if (esSeleccionado) FontWeight.Bold else FontWeight.Normal,
                            color = if (esSeleccionado) MaterialTheme.colorScheme.primary else MaterialTheme.colorScheme.onSurface
                        )
                        Text(
                            text = producto.precioFormateado(),
                            color = if (esSeleccionado) MaterialTheme.colorScheme.primary else MaterialTheme.colorScheme.onSurface,
                            fontWeight = if (esSeleccionado) FontWeight.Bold else FontWeight.Normal
                        )
                    }
                    HorizontalDivider()
                }
            }
        }

        Spacer(modifier = Modifier.height(16.dp))

        // Campo 1: Número de Producto (1-5)
        OutlinedTextField(
            value = numeroProductoTexto,
            onValueChange = {
                numeroProductoTexto = it
                mensajeError = null
                resumenCompra = null
            },
            label = { Text("Número del producto (1 - 5)") },
            placeholder = { Text("Ejemplo: 1 para Teclado") },
            keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number),
            modifier = Modifier.fillMaxWidth(),
            singleLine = true
        )

        Spacer(modifier = Modifier.height(8.dp))

        Text(
            text = "Producto seleccionado: ${productoSeleccionado?.let { "${it.nombre} (${it.precioFormateado()})" } ?: "Ninguno"}",
            fontWeight = FontWeight.SemiBold,
            color = if (productoSeleccionado != null) MaterialTheme.colorScheme.primary else MaterialTheme.colorScheme.error
        )

        Spacer(modifier = Modifier.height(12.dp))

        // Campo 2: Cantidad de unidades
        OutlinedTextField(
            value = cantidadTexto,
            onValueChange = {
                cantidadTexto = it
                mensajeError = null
                resumenCompra = null
            },
            label = { Text("Cantidad de unidades") },
            placeholder = { Text("Ejemplo: 5") },
            keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number),
            modifier = Modifier.fillMaxWidth(),
            singleLine = true
        )

        Spacer(modifier = Modifier.height(16.dp))

        Button(
            onClick = {
                val numProd = numeroProductoTexto.toIntOrNull()
                if (numProd == null || numProd < 1 || numProd > catalogo.size) {
                    mensajeError = "❌ ERROR: Selección inválida. Debe ingresar un número de producto entre 1 y ${catalogo.size} (o hacer clic en el catálogo)."
                    resumenCompra = null
                    return@Button
                }

                val producto = catalogo.first { it.id == numProd }

                val cantidad = cantidadTexto.toIntOrNull()
                if (cantidad == null || cantidad <= 0) {
                    mensajeError = "❌ ERROR: Cantidad inválida. Debe ingresar un número entero mayor a cero."
                    resumenCompra = null
                    return@Button
                }

                mensajeError = null
                val subtotal = producto.precio * cantidad
                val descuento = if (subtotal > umbralDescuento) subtotal * porcentajeDescuento else 0.0
                val total = subtotal - descuento

                resumenCompra = ResumenData(
                    productoNombre = producto.nombre,
                    precioUnitario = producto.precioFormateado(),
                    cantidad = cantidad,
                    subtotal = subtotal,
                    descuento = descuento,
                    total = total
                )
            },
            modifier = Modifier.fillMaxWidth()
        ) {
            Text("Calcular / Simular Compra", fontSize = 16.sp)
        }

        mensajeError?.let { error ->
            Spacer(modifier = Modifier.height(12.dp))
            Text(
                text = error,
                color = MaterialTheme.colorScheme.error,
                fontWeight = FontWeight.Bold
            )
        }

        resumenCompra?.let { resumen ->
            Spacer(modifier = Modifier.height(16.dp))
            Card(
                colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surfaceVariant),
                modifier = Modifier.fillMaxWidth()
            ) {
                Column(modifier = Modifier.padding(16.dp)) {
                    Text("=== RESUMEN DE COMPRA ===", fontWeight = FontWeight.Bold, fontSize = 16.sp)
                    Spacer(modifier = Modifier.height(8.dp))
                    Text("Producto seleccionado: ${resumen.productoNombre}")
                    Text("Precio unitario: ${resumen.precioUnitario}")
                    Text("Cantidad: ${resumen.cantidad} unidad(es)")
                    HorizontalDivider(modifier = Modifier.padding(vertical = 6.dp))
                    Text("Subtotal: \$${resumen.subtotal.toInt()}")
                    if (resumen.descuento > 0) {
                        Text("Descuento (10%): -\$${resumen.descuento.toInt()}", color = MaterialTheme.colorScheme.primary, fontWeight = FontWeight.Bold)
                    } else {
                        Text("Descuento aplicado: \$0 (No aplica)")
                    }
                    HorizontalDivider(modifier = Modifier.padding(vertical = 6.dp))
                    Text(
                        text = "TOTAL A PAGAR: \$${resumen.total.toInt()}",
                        fontWeight = FontWeight.Bold,
                        fontSize = 17.sp,
                        color = MaterialTheme.colorScheme.primary
                    )
                }
            }
        }
    }
}
