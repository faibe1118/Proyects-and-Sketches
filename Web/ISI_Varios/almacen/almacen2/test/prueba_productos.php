<?php
// URL del API de productos
$url = "http://localhost/almacen2/apis/get_productos.php";

// Utilizar file_get_contents para hacer una solicitud GET al API
$response = file_get_contents($url);

// Verificar si se recibió una respuesta
if ($response === FALSE) {
    die("Error al conectar con el API de productos.");
}

// Decodificar la respuesta JSON
$productos = json_decode($response, true);

// Verificar si la decodificación fue exitosa
if (is_array($productos) && count($productos) > 0) {
    // Generar la tabla HTML con los productos
    echo "<h2>Lista de Productos</h2>";
    echo "<table border='1' cellpadding='10' cellspacing='0'>";
    echo "<tr><th>Código</th><th>Descripción</th><th>Unidad</th><th>Cantidad</th></tr>";

    // Recorrer cada producto y agregar una fila a la tabla
    foreach ($productos as $producto) {
        echo "<tr>";
        echo "<td>" . htmlspecialchars($producto['codigoA']) . "</td>";
        echo "<td>" . htmlspecialchars($producto['descripcion']) . "</td>";
        echo "<td>" . htmlspecialchars($producto['unidad']) . "</td>";
        echo "<td>" . htmlspecialchars($producto['cantidad']) . "</td>";
        echo "</tr>";
    }

    echo "</table>";
} else {
    // Mostrar mensaje si no se encuentran productos
    echo "<h3>No se encontraron productos o hubo un error al procesar la respuesta del API.</h3>";
}
?>
