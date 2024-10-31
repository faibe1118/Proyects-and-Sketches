<?php
// Incluir la configuración de conexión
include '../config.php';

// Crear la conexión
$conn = new mysqli($servername, $username, $password, $dbname);

// Verificar la conexión
if ($conn->connect_error) {
    die("Error de conexión: " . $conn->connect_error);
}

// Consulta SQL para obtener la cantidad de asignaturas matriculadas por estudiantes mayores de 21 años
$sql = "SELECT e.nombre, e.apellido, COUNT(m.codigoA) as cantidad_asignaturas
        FROM estudiante e
        JOIN matricula m ON e.codigoE = m.codigoE
        WHERE e.edad > 21
        GROUP BY e.codigoE, e.nombre, e.apellido";

$result = $conn->query($sql);

$estudiantes = [];

if ($result->num_rows > 0) {
    // Convertir los datos en un formato JSON
    while($row = $result->fetch_assoc()) {
        $estudiantes[] = $row;
    }
    echo json_encode($estudiantes);
} else {
    echo json_encode(array("message" => "No se encontraron resultados"));
}

// Cerrar la conexión
$conn->close();
?>