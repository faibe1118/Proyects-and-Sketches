<?php
// Incluir la configuración de conexión
include '../config.php';

// Crear la conexión
$conn = new mysqli($servername, $username, $password, $dbname);

// Verificar la conexión
if ($conn->connect_error) {
    die("Error de conexión: " . $conn->connect_error);
}

// Consulta SQL para obtener el promedio más bajo en la asignatura 'Informática'
$sql = "SELECT e.nombre, e.apellido, m.promedio
        FROM estudiante e
        JOIN matricula m ON e.codigoE = m.codigoE
        JOIN asignatura a ON a.codigoA = m.codigoA
        WHERE a.nombre = 'Informática'
        ORDER BY m.promedio ASC
        LIMIT 1";

$result = $conn->query($sql);

if ($result->num_rows > 0) {
    // Salida de datos en formato JSON
    $row = $result->fetch_assoc();
    echo json_encode($row);
} else {
    echo json_encode(array("message" => "No se encontraron resultados"));
}

// Cerrar la conexión
$conn->close();
?>