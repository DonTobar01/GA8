import 'dart:convert';
import 'package:http/http.dart' as http;

class Herramientas {
  final int id;
  final String nombre;
  final String descripcion;
  final int cantidad;

  Herramientas({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.cantidad,
  });

  factory Herramientas.fromJson(Map<String, dynamic> json) {
    return Herramientas(
      id: int.tryParse(json['id']) ?? 0,
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      cantidad: int.tryParse(json['cantidad']) ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'cantidad': cantidad,
    };
  }
}

// Obtener la lista de herramientas (READ)
Future<List<Herramientas>> consultarHerramientas() async {
  var url = Uri.parse('http://localhost:8888/api-herramientas/endpoints/herramientas.php');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final List<dynamic> body = json.decode(response.body);
    return body.map((json) => Herramientas.fromJson(json)).toList();
  } else {
    throw Exception('Error al cargar herramientas');
  }
}

// Crear una nueva herramienta (CREATE)
Future<Herramientas> crearHerramienta(Herramientas herramienta) async {
  var url = Uri.parse('http://localhost:8888/api-herramientas/endpoints/herramientas.php');
  final response = await http.post(
    url,
    headers: {"Content-Type": "application/json"},
    body: json.encode(herramienta.toJson()),
  );

  if (response.statusCode == 201) {
    return Herramientas.fromJson(json.decode(response.body));
  } else {
    throw Exception('Error al crear la herramienta');
  }
}

// Actualizar una herramienta existente (UPDATE)
Future<Herramientas> actualizarHerramienta(Herramientas herramienta) async {
  var url = Uri.parse('http://localhost:8888/api-herramientas/endpoints/herramientas.php?id=${herramienta.id}');
  final response = await http.put(
    url,
    headers: {"Content-Type": "application/json"},
    body: json.encode(herramienta.toJson()),
  );

  if (response.statusCode == 200) {
    return Herramientas.fromJson(json.decode(response.body));
  } else {
    throw Exception('Error al actualizar la herramienta');
  }
}

// Eliminar una herramienta (DELETE)
Future<void> eliminarHerramienta(int id) async {
  var url = Uri.parse('http://localhost:8888/api-herramientas/endpoints/herramientas.php?id=$id');
  final response = await http.delete(url);

  if (response.statusCode != 200) {
    throw Exception('Error al eliminar la herramienta');
  }
}
