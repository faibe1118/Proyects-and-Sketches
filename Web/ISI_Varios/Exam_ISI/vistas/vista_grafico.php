<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cantidad de Asignaturas Matriculadas</title>
    <!-- Incluir Chart.js desde CDN -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>
    <h1>Cantidad de Asignaturas por Estudiantes (Mayores de 21 Años)</h1>

    <!-- Canvas para el gráfico -->
    <canvas id="graficoAsignaturas" width="400" height="200"></canvas>

    <?php
    // Incluir el archivo del controlador
    include '../controlador/controlador_cantidad_asignaturas.php';

    // Crear una instancia del controlador con la URL de la API
    $controlador = new ControladorAsignaturas('http://localhost/Exam_ISI/API/get_cantidad_asignaturas_por_estudiantes_mayores_21.php');

    // Obtener los datos de la API
    $asignaturas = $controlador->obtenerCantidadAsignaturas();
    ?>

    <?php if ($asignaturas && !isset($asignaturas['message'])): ?>
        <script>
            // Obtener los nombres de los estudiantes y la cantidad de asignaturas desde PHP
            const nombresEstudiantes = <?php echo json_encode(array_map(function($estudiante) {
                return $estudiante['nombre'] . ' ' . $estudiante['apellido'];
            }, $asignaturas)); ?>;

            const cantidadesAsignaturas = <?php echo json_encode(array_map(function($estudiante) {
                return $estudiante['cantidad_asignaturas'];
            }, $asignaturas)); ?>;

            // Crear el gráfico usando Chart.js
            const ctx = document.getElementById('graficoAsignaturas').getContext('2d');
            const graficoAsignaturas = new Chart(ctx, {
                type: 'bar', // Tipo de gráfico de barras
                data: {
                    labels: nombresEstudiantes, // Nombres de los estudiantes en el eje X
                    datasets: [{
                        label: 'Cantidad de Asignaturas',
                        data: cantidadesAsignaturas, // Cantidad de asignaturas en el eje Y
                        backgroundColor: 'rgba(75, 192, 192, 0.2)',
                        borderColor: 'rgba(75, 192, 192, 1)',
                        borderWidth: 1
                    }]
                },
                options: {
                    scales: {
                        y: {
                            beginAtZero: true
                        }
                    }
                }
            });
        </script>
    <?php else: ?>
        <p>No se encontraron resultados o hubo un error.</p>
    <?php endif; ?>
</body>
</html>