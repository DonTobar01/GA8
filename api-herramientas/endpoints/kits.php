<?php

// Permitir solicitudes desde cualquier origen
header("Access-Control-Allow-Origin: *");

// Permitir métodos HTTP específicos
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE");

// Permitir encabezados específicos
header("Access-Control-Allow-Headers: Content-Type, Authorization");


require_once('../config/conexion.php');

// Obtener todas las herramientas
$query = "SELECT * FROM kits";
$result = $conn->query($query);

$kits = array();

if ($result->num_rows > 0) {
    while($row = $result->fetch_assoc()) {
        $kits[] = $row;
    }
}

echo json_encode($kits);
?>
