<?php
// Incluir el controlador
include '../controlador/controlador_promedio.php';

// Crear una instancia del controlador con la URL de la API
$controlador = new ControladorPromedio('http://localhost/Exam_ISI/API/get_promedio_bajo_info.php');

// Obtener los datos del promedio más bajo
$resultado = $controlador->obtenerPromedioBajo();
?>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Promedio más bajo en Informática</title>
    <style>
        table {
            width: 50%;
            border-collapse: collapse;
            margin: 50px 0;
            font-size: 18px;
            text-align: left;
        }
        th, td {
            padding: 12px;
            border-bottom: 1px solid #ddd;
        }
        th {
            background-color: #f2f2f2;
        }
    </style>
</head>
<body>
    <h1>Promedio más bajo en Informática</h1>

    <?php if ($resultado && !isset($resultado['message'])): ?>
        <table>
            <thead>
                <tr>
                    <th>Nombre del estudiante</th>
                    <th>Apellido</th>
                    <th>Promedio</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td><?php echo htmlspecialchars($resultado['nombre']); ?></td>
                    <td><?php echo htmlspecialchars($resultado['apellido']); ?></td>
                    <td><?php echo htmlspecialchars($resultado['promedio']); ?></td>
                </tr>
            </tbody>
        </table>
    <?php else: ?>
        <p><?php echo isset($resultado['message']) ? htmlspecialchars($resultado['message']) : 'Error al obtener los datos'; ?></p>
    <?php endif; ?>
</body>
</html>