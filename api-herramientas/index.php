
/*/
header('Content-Type: application/json');
require_once './endpoints/herramienta.php';

$metodo = $_SERVER['REQUEST_METHOD'];
$herramienta = new Herramienta();

switch ($metodo) {
    case 'GET':
        $datos = $herramienta->obtenerHerramientas();
        echo json_encode($datos);
        break;
    
    case 'POST':
        $data = json_decode(file_get_contents("php://input"));
        if ($herramienta->crearHerramienta($data->nombre, $data->descripcion, $data->cantidad)) {
            echo json_encode(["mensaje" => "Herramienta creada exitosamente."]);
        } else {
            echo json_encode(["mensaje" => "Error al crear la herramienta."]);
        }
        break;

    case 'PUT':
        $data = json_decode(file_get_contents("php://input"));
        if ($herramienta->actualizarHerramienta($data->id, $data->nombre, $data->descripcion, $data->cantidad, $data->estado)) {
            echo json_encode(["mensaje" => "Herramienta actualizada."]);
        } else {
            echo json_encode(["mensaje" => "Error al actualizar la herramienta."]);
        }
        break;

    case 'DELETE':
        $data = json_decode(file_get_contents("php://input"));
        if ($herramienta->eliminarHerramienta($data->id)) {
            echo json_encode(["mensaje" => "Herramienta eliminada."]);
        } else {
            echo json_encode(["mensaje" => "Error al eliminar la herramienta."]);
        }
        break;

    default:
        echo json_encode(["mensaje" => "Método no soportado."]);
        break;
}
?>
