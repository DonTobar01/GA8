<?php
$servername = "localhost";
$username = "root";
$password = "root";  // o la contraseña que hayas configurado en MAMP
$dbname = "gestion_herramientas";

// Crear conexión
$conn = new mysqli($servername, $username, $password, $dbname);

// Verificar conexión
if ($conn->connect_error) {
    die("Conexión fallida: " . $conn->connect_error);
}
?>
<?php
// Include your database connection
include 'conexion.php';

header('Content-Type: application/json');

$sql = "SELECT * FROM operarios";
$result = $conn->query($sql);

$operarios = array();
if ($result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
        $operarios[] = $row;
    }
}

echo json_encode($operarios);
?>

