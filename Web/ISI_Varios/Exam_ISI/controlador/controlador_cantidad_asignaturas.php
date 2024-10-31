<?php
class ControladorAsignaturas {
    private $apiUrl;

    public function __construct($apiUrl) {
        $this->apiUrl = $apiUrl;
    }

    // Método para obtener la cantidad de asignaturas de estudiantes mayores de 21 años
    public function obtenerCantidadAsignaturas() {
        // Iniciar cURL
        $curl = curl_init();

        curl_setopt($curl, CURLOPT_URL, $this->apiUrl);
        curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);

        // Ejecutar la solicitud
        $response = curl_exec($curl);

        // Si hay un error con cURL, mostrar el error
        if (curl_errno($curl)) {
            echo 'Error en cURL: ' . curl_error($curl);
            return null;
        }

        // Obtener el código de respuesta HTTP
        $httpCode = curl_getinfo($curl, CURLINFO_HTTP_CODE);

        // Cerrar cURL
        curl_close($curl);

        // Verificar si la solicitud fue exitosa
        if ($httpCode == 200) {
            // Convertir el resultado JSON en un array asociativo
            $data = json_decode($response, true);
            return $data;
        } else {
            // En caso de error, mostrar el código HTTP
            echo "Error: Código HTTP " . $httpCode;
            return null;
        }
    }
}