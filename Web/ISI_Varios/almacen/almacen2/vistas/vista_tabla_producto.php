<?php
// vista_tabla_producto.php

// Incluir el controlador que obtiene los productos
include '../controlador/controlador_productos.php';

// Obtener la lista de productos desde el controlador
$productos = obtenerProductos();
?>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tabla de Productos</title>
    <style>
        table {
            width: 80%;
            border-collapse: collapse;
            margin: 20px auto;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 8px;
            text-align: center;
        }
        th {
            background-color: #f2f2f2;
        }
        tr:nth-child(even) {
            background-color: #f9f9f9;
        }
    </style>
</head>
<body>
    <h2 style="text-align: center;">Lista de Productos</h2>
    <table>
        <tr>
            <th>Código</th>
            <th>Descripción</th>
            <th>Unidad</th>
            <th>Cantidad</th>
        </tr>
        <?php if (is_array($productos) && count($productos) > 0): ?>
            <?php foreach ($productos as $producto): ?>
                <tr>
                    <td><?php echo htmlspecialchars($producto['codigoA']); ?></td>
                    <td><?php echo htmlspecialchars($producto['descripcion']); ?></td>
                    <td><?php echo htmlspecialchars($producto['unidad']); ?></td>
                    <td><?php echo htmlspecialchars($producto['cantidad']); ?></td>
                </tr>
            <?php endforeach; ?>
        <?php else: ?>
            <tr>
                <td colspan="4">No se encontraron productos.</td>
            </tr>
        <?php endif; ?>
    </table>
</body>
</html>
