<?php
// insertar_producto_api.php

// Incluir el archivo de configuración para conectarse a la base de datos
include 'config.php';

// Definir la cabecera para devolver el contenido en formato JSON
header('Content-Type: application/json');

// Verificar si los datos fueron enviados correctamente
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $codigoA = $_POST['codigoA'];
    $descripcion = $_POST['descripcion'];
    $unidad = $_POST['unidad'];
    $cantidad = $_POST['cantidad'];

    // Preparar la consulta SQL para insertar el producto
    $sql = "INSERT INTO productos (codigoA, descripcion, unidad, cantidad) VALUES (?, ?, ?, ?)";

    // Preparar la consulta utilizando PDO
    $stmt = $conn->prepare($sql);
    $stmt->bindParam(1, $codigoA);
    $stmt->bindParam(2, $descripcion);
    $stmt->bindParam(3, $unidad);
    $stmt->bindParam(4, $cantidad);

    // Ejecutar la consulta y verificar si se insertó correctamente
    if ($stmt->execute()) {
        echo json_encode(array("mensaje" => "Producto insertado con éxito"));
    } else {
        echo json_encode(array("mensaje" => "Error al insertar el producto"));
    }

    // Cerrar la conexión
    $conn = null;
} else {
    echo json_encode(array("mensaje" => "Método no permitido"));
}
?>
