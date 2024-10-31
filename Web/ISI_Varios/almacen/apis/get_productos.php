<?php
// Incluir el archivo de configuración para la conexión a la base de datos
include 'config.php';

// Definir la cabecera para devolver el contenido en formato JSON
header('Content-Type: application/json');

try {
    // Consulta SQL para obtener todos los productos
    $sql = "SELECT codigoA, descripcion, unidad, cantidad FROM productos";
    
    // Preparar la consulta
    $stmt = $conn->prepare($sql);
    
    // Ejecutar la consulta
    $stmt->execute();
    
    // Obtener todos los resultados en un array asociativo
    $productos = $stmt->fetchAll(PDO::FETCH_ASSOC);

    // Verificar si se encontraron productos
    if (count($productos) > 0) {
        // Devolver los productos en formato JSON
        echo json_encode($productos, JSON_PRETTY_PRINT);
    } else {
        // Devolver un mensaje si no se encuentran productos
        echo json_encode(array("mensaje" => "No se encontraron productos"));
    }
} catch (PDOException $e) {
    // En caso de error, devolver el mensaje de error en formato JSON
    echo json_encode(array("error" => $e->getMessage()));
}

// Cerrar la conexión
$conn = null;
?>
