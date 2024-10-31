<?php
// config.php

$host = "localhost";
$bd = "proveedores";
$usuario = "root";
$password = "";  //colocar el password de conexión a la base de datos

try {
    // Crear una conexión con PDO
    $conn = new PDO("mysql:host=$host;dbname=$bd;charset=utf8", $usuario, $password);
    // Establecer el modo de error de PDO para excepciones
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    // Mostrar mensaje de error si no se puede conectar
    die("Error en la conexión: " . $e->getMessage());
}
?>
