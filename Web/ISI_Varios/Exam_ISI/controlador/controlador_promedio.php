<?php
class ControladorPromedio {
    private $apiUrl;

    public function __construct($apiUrl) {
        $this->apiUrl = $apiUrl;
    }

    // Método para obtener el promedio más bajo de la API
    public function obtenerPromedioBajo() {
        // Iniciar cURL
        $curl = curl_init();

        curl_setopt($curl, CURLOPT_URL, $this->apiUrl);
        curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);

        $response = curl_exec($curl);

        if (curl_errno($curl)) {
            echo 'Error en cURL: ' . curl_error($curl);
            return null;
        }

        curl_close($curl);

        // Convertir el resultado JSON a un array asociativo
        $data = json_decode($response, true);

        // Retornar los datos obtenidos
        return $data;
    }
}
