<?php

// Permitir solicitudes desde cualquier origen
header("Access-Control-Allow-Origin: *");

// Permitir métodos HTTP específicos
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE");

// Permitir encabezados específicos
header("Access-Control-Allow-Headers: Content-Type, Authorization");


require_once('../config/conexion.php');

// Obtener todas las herramientas
$query = "SELECT * FROM operarios";
$result = $conn->query($query);

$operarios = array();

if ($result->num_rows > 0) {
    while($row = $result->fetch_assoc()) {
        $operarios[] = $row;
    }
}

echo json_encode($operarios);
?>

<?php
include 'conexion.php';

header('Content-Type: application/json');

// Recibe el input de la solicitud
$data = json_decode(file_get_contents("php://input"));

$nombre = $data->nombre;
$cargo = $data->cargo;

$sql = "INSERT INTO operarios (nombre, cargo) VALUES ('$nombre', '$cargo')";

if ($conn->query($sql) === TRUE) {
    echo json_encode(["mensaje" => "Operario creado correctamente"]);
} else {
    echo json_encode(["error" => "Error al crear operario: " . $conn->error]);
}
?>
<?php
include 'conexion.php';

header('Content-Type: application/json');

$id = $_GET['id'];  // ID enviado en la URL

$data = json_decode(file_get_contents("php://input"));
$nombre = $data->nombre;
$cargo = $data->cargo;

$sql = "UPDATE operarios SET nombre='$nombre', cargo='$cargo' WHERE id=$id";

if ($conn->query($sql) === TRUE) {
    echo json_encode(["mensaje" => "Operario actualizado correctamente"]);
} else {
    echo json_encode(["error" => "Error al actualizar operario: " . $conn->error]);
}
?>
<?php
include 'conexion.php';

header('Content-Type: application/json');

$id = $_GET['id'];

$sql = "DELETE FROM operarios WHERE id=$id";

if ($conn->query($sql) === TRUE) {
    echo json_encode(["mensaje" => "Operario eliminado correctamente"]);
} else {
    echo json_encode(["error" => "Error al eliminar operario: " . $conn->error]);
}
?>
