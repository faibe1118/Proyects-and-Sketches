<?php
// controlador_productos.php

// Función para obtener la lista de productos desde el API
function obtenerProductos() {
    $url = "http://localhost/almacen2/apis/get_productos.php"; // URL del API de productos
    $response = file_get_contents($url);

    if ($response === FALSE) {
        die("Error al conectar con el API de productos.");
    }

    $productos = json_decode($response, true);
    return $productos;
}

// Función para insertar un producto utilizando el API
function insertarProducto($codigoA, $descripcion, $unidad, $cantidad) {
    $url = "http://localhost/almacen2/apis/insertar_producto_api.php"; // URL del API para insertar productos

    // Crear el array de datos a enviar
    $data = array(
        'codigoA' => $codigoA,
        'descripcion' => $descripcion,
        'unidad' => $unidad,
        'cantidad' => $cantidad
    );

    // Configurar la solicitud con opciones y parámetros
    $options = array(
        'http' => array(
            'header'  => "Content-type: application/x-www-form-urlencoded",
            'method'  => 'POST',
            'content' => http_build_query($data),
        ),
    );

    $context = stream_context_create($options);
    $response = file_get_contents($url, false, $context);

    if ($response === FALSE) {
        die("Error al insertar el producto.");
    }

    return json_decode($response, true); // Retorna la respuesta del API
}

// Procesar la solicitud POST desde el formulario de `insertar_productos.html`
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $codigoA = $_POST['codigoA'];
    $descripcion = $_POST['descripcion'];
    $unidad = $_POST['unidad'];
    $cantidad = $_POST['cantidad'];

    // Llamar a la función para insertar el producto
    $resultado = insertarProducto($codigoA, $descripcion, $unidad, $cantidad);

    // Redirigir de nuevo a `insertar_productos.html` con un mensaje de éxito o error
    header("Location: insertar_productos.html?mensaje=" . urlencode($resultado['mensaje']));
    exit;
}
?>
