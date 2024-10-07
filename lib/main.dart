import 'package:flutter/material.dart';
import 'api_herramientas.dart'; 
import 'api_kits.dart'; 

void main() {
  runApp(const GestionHerramientasApp());
}

class GestionHerramientasApp extends StatelessWidget {
  const GestionHerramientasApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestión de Herramientas',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HerramientasScreen(),
    );
  }
}

class HerramientasScreen extends StatefulWidget {
  const HerramientasScreen({Key? key}) : super(key: key);

  @override
  _HerramientasScreenState createState() => _HerramientasScreenState();
}

class _HerramientasScreenState extends State<HerramientasScreen> {
  late Future<List<Herramientas>> futureHerramientas;

  @override
  void initState() {
    super.initState();
    futureHerramientas = consultarHerramientas();
  }

  void _agregarHerramienta() async {
    final nuevaHerramienta = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HerramientaFormScreen()),
    );

    if (nuevaHerramienta != null) {
      await crearHerramienta(nuevaHerramienta);
      setState(() {
        futureHerramientas = consultarHerramientas();
      });
    }
  }

  void _editarHerramienta(Herramientas herramienta) async {
    final herramientaActualizada = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HerramientaFormScreen(herramienta: herramienta)),
    );

    if (herramientaActualizada != null) {
      await actualizarHerramienta(herramientaActualizada);
      setState(() {
        futureHerramientas = consultarHerramientas();
      });
    }
  }

  void _eliminarHerramienta(int id) async {
    await eliminarHerramienta(id);
    setState(() {
      futureHerramientas = consultarHerramientas();
    });
  }

  void _irKits() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const KitsScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Herramientas'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Navegación',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              title: const Text('Agregar Herramienta'),
              onTap: () {
                Navigator.pop(context);
                _agregarHerramienta();
              },
            ),
            ListTile(
              title: const Text('Gestionar Kits'),
              onTap: () {
                Navigator.pop(context);
                _irKits();
              },
            ),
          ],
        ),
      ),
      body: FutureBuilder<List<Herramientas>>(
        future: futureHerramientas,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay herramientas disponibles.'));
          }

          final herramientas = snapshot.data!;

          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.8,
            ),
            itemCount: herramientas.length,
            itemBuilder: (context, index) {
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    _editarHerramienta(herramientas[index]);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ListTile(
                        title: Text(herramientas[index].nombre),
                        subtitle: Text('Cantidad: ${herramientas[index].cantidad}'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          herramientas[index].descripcion,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              _eliminarHerramienta(herramientas[index].id);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class HerramientaFormScreen extends StatefulWidget {
  final Herramientas? herramienta;

  const HerramientaFormScreen({Key? key, this.herramienta}) : super(key: key);

  @override
  _HerramientaFormScreenState createState() => _HerramientaFormScreenState();
}

class _HerramientaFormScreenState extends State<HerramientaFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nombreController;
  late TextEditingController _descripcionController;
  late TextEditingController _cantidadController;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.herramienta?.nombre ?? '');
    _descripcionController = TextEditingController(text: widget.herramienta?.descripcion ?? '');
    _cantidadController = TextEditingController(text: widget.herramienta?.cantidad.toString() ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.herramienta == null ? 'Nueva Herramienta' : 'Editar Herramienta'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa un nombre';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descripcionController,
                decoration: const InputDecoration(labelText: 'Descripción'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa una descripción';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _cantidadController,
                decoration: const InputDecoration(labelText: 'Cantidad'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa una cantidad';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final nuevaHerramienta = Herramientas(
                      id: widget.herramienta?.id ?? 0,
                      nombre: _nombreController.text,
                      descripcion: _descripcionController.text,
                      cantidad: int.parse(_cantidadController.text),
                    );
                    Navigator.pop(context, nuevaHerramienta);
                  }
                },
                child: const Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class KitsScreen extends StatefulWidget {
  const KitsScreen({Key? key}) : super(key: key);

  @override
  _KitsScreenState createState() => _KitsScreenState();
}

class _KitsScreenState extends State<KitsScreen> {
  late Future<List<Kits>> futureKits;

  @override
  void initState() {
    super.initState();
    futureKits = consultarKits();
  }

  void _agregarKit() async {
    final nuevoKit = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const KitFormScreen()),
    );

    if (nuevoKit != null) {
      await crearKit(nuevoKit);
      setState(() {
        futureKits = consultarKits();
      });
    }
  }

  void _editarKit(Kits kit) async {
    final kitActualizado = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => KitFormScreen(kit: kit)),
    );

    if (kitActualizado != null) {
      await actualizarKit(kitActualizado);
      setState(() {
        futureKits = consultarKits();
      });
    }
  }

  void _eliminarKit(int id) async {
    await eliminarKit(id);
    setState(() {
      futureKits = consultarKits();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestionar Kits'),
      ),
      body: FutureBuilder<List<Kits>>(
        future: futureKits,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay kits disponibles.'));
          }

          final kits = snapshot.data!;

          return ListView.builder(
            itemCount: kits.length,
            itemBuilder: (context, index) {
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(kits[index].nombre),
                  subtitle: Text(kits[index].descripcion),
                  onTap: () {
                    _editarKit(kits[index]);
                  },
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      _eliminarKit(kits[index].id);
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _agregarKit,
        tooltip: 'Agregar Kit',
        child: const Icon(Icons.add),
      ),
    );
  }
}

// Pantalla para agregar o editar un kit
class KitFormScreen extends StatefulWidget {
  final Kits? kit;

  const KitFormScreen({Key? key, this.kit}) : super(key: key);

  @override
  _KitFormScreenState createState() => _KitFormScreenState();
}

class _KitFormScreenState extends State<KitFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nombreController;
  late TextEditingController _descripcionController;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.kit?.nombre ?? '');
    _descripcionController = TextEditingController(text: widget.kit?.descripcion ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.kit == null ? 'Nuevo Kit' : 'Editar Kit'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa un nombre';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descripcionController,
                decoration: const InputDecoration(labelText: 'Descripción'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa una descripción';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final nuevoKit = Kits(
                      id: widget.kit?.id ?? 0,
                      nombre: _nombreController.text,
                      descripcion: _descripcionController.text,
                    );
                    Navigator.pop(context, nuevoKit);
                  }
                },
                child: const Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
