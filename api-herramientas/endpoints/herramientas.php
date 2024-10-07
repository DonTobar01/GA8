<?php

// Permitir solicitudes desde cualquier origen
header("Access-Control-Allow-Origin: *");

// Permitir métodos HTTP específicos
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE");

// Permitir encabezados específicos
header("Access-Control-Allow-Headers: Content-Type, Authorization");

require_once('../config/conexion.php');

// Obtener todas las herramientas
$query = "SELECT * FROM herramientas";
$result = $conn->query($query);

$herramientas = array();

if ($result->num_rows > 0) {
    while($row = $result->fetch_assoc()) {
        $herramientas[] = $row;
    }
}

echo json_encode($herramientas);
?>
