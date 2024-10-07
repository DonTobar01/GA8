import 'dart:convert';
import 'package:http/http.dart' as http;

class Kits {
  final int id;
  final String nombre;
  final String descripcion;

  Kits({required this.id, required this.nombre, required this.descripcion});

  factory Kits.fromJson(Map<String, dynamic> json) {
    return Kits(
      id: int.tryParse(json['id']) ?? 0,
      nombre: json['nombre'],
      descripcion: json['descripcion'],
    );
  }
}

Future<List<Kits>> consultarKits() async {
  var url = Uri.parse("http://localhost:8888/api-herramientas/endpoints/kits.php");
  final response = await http.get(url);

  if (response.statusCode == 200) {
    return List<Kits>.from(json.decode(response.body).map((x) => Kits.fromJson(x)));
  } else {
    throw Exception('Error al cargar kits: ${response.statusCode}');
  }
}

Future<void> crearKit(Kits kit) async {
  var url = Uri.parse("http://localhost:8888/api-herramientas/endpoints/kits.php");
  await http.post(
    url,
    headers: {"Content-Type": "application/json"},
    body: json.encode({
      'nombre': kit.nombre,
      'descripcion': kit.descripcion,
    }),
  );
}

Future<void> actualizarKit(Kits kit) async {
  var url = Uri.parse("http://localhost:8888/api-herramientas/endpoints/kits.php?id=${kit.id}");
  await http.put(
    url,
    headers: {"Content-Type": "application/json"},
    body: json.encode({
      'nombre': kit.nombre,
      'descripcion': kit.descripcion,
    }),
  );
}

Future<void> eliminarKit(int id) async {
  var url = Uri.parse("http://localhost:8888/api-herramientas/endpoints/kits.php?id=$id");
  await http.delete(url);
}
