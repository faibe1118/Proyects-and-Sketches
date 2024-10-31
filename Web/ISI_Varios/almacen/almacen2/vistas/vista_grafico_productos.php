<?php
// vista_grafico_productos.php

// Incluir el controlador que obtiene los productos
include '../controlador/controlador_productos.php';

// Obtener la lista de productos desde el controlador
$productos = obtenerProductos();

// Contar las cantidades por cada tipo de unidad
$conteoUnidades = array("Unidad" => 0, "Caja" => 0, "Kilogramo" => 0);
foreach ($productos as $producto) {
    if (isset($conteoUnidades[$producto['unidad']])) {
        $conteoUnidades[$producto['unidad']] += $producto['cantidad'];
    }
}
?>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gráfico de Productos por Unidad</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>
    <h2 style="text-align: center;">Gráfico de Productos Agrupado por Unidad</h2>
    <div style="width: 60%; margin: auto;">
        <canvas id="graficoUnidades"></canvas>
    </div>

    <script>
        // Obtener el contexto del lienzo donde se dibujará el gráfico
        const ctx = document.getElementById('graficoUnidades').getContext('2d');

        // Crear un gráfico de barras utilizando Chart.js
        const graficoUnidades = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: ['Unidad', 'Caja', 'Kilogramo'],
                datasets: [{
                    label: 'Cantidad de Productos por Unidad',
                    data: [
                        <?php echo $conteoUnidades['Unidad']; ?>,
                        <?php echo $conteoUnidades['Caja']; ?>,
                        <?php echo $conteoUnidades['Kilogramo']; ?>
                    ],
                    backgroundColor: ['#4e73df', '#1cc88a', '#36b9cc'],
                    borderColor: ['#4e73df', '#1cc88a', '#36b9cc'],
                    borderWidth: 1
                }]
            },
            options: {
                scales: {
                    y: {
                        beginAtZero: true
                    }
                },
                plugins: {
                    legend: {
                        position: 'top',
                    },
                    title: {
                        display: true,
                        text: 'Cantidad de Productos por Unidad'
                    }
                }
            }
        });
    </script>
</body>
</html>
