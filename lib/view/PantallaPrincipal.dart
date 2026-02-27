import 'dart:async';
import 'package:flutter/material.dart';
import 'AddApp.dart';
import 'Modelo_App.dart';

class PantallaPrincipal extends StatefulWidget {
  const PantallaPrincipal({super.key});

  @override
  State<PantallaPrincipal> createState() => _PantallaPrincipalState();
}

class _PantallaPrincipalState extends State<PantallaPrincipal> {

  List<Modelo_App> appsRestringidas = [];

  Timer? timer;

  @override
  void initState() {

    super.initState();

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {

      setState(() {});

    });

  }

  @override
  void dispose() {

    timer?.cancel();

    super.dispose();

  }

  void abrirAddApp() async {

    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddApp(appsSeleccionadas: appsRestringidas),
      ),
    );

    if (resultado != null) {

      setState(() {

        for (var nuevaApp in resultado) {

          final existe = appsRestringidas.where(
            (app) => app.nombre == nuevaApp.nombre,
          );

          if (existe.isEmpty) {

            appsRestringidas.add(nuevaApp);

          } else {

            nuevaApp.minutos = existe.first.minutos;
            nuevaApp.tiempoInicio = existe.first.tiempoInicio;

          }

        }

        appsRestringidas.removeWhere(
          (app) => !resultado.any(
            (seleccionada) => seleccionada.nombre == app.nombre,
          ),
        );

      });

    }

  }

  void abrirPerfil() {

    print("Abrir perfil");

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFFF5EDFF),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF6C63FF),
        onPressed: abrirAddApp,
        child: const Icon(Icons.add),
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              /// HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  Row(
                    children: [

                      Image.asset(
                        "assets/imagenes/icono.png",
                        width: 35,
                        height: 35,
                      ),

                      const SizedBox(width: 10),

                      const Text(
                        "FOCUS MODE",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF232946),
                        ),
                      ),

                    ],
                  ),

                  GestureDetector(
                    onTap: abrirPerfil,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(color: Colors.black12, blurRadius: 4),
                        ],
                      ),
                      child: Icon(
                        Icons.person,
                        color: Colors.grey[700],
                        size: 26,
                      ),
                    ),
                  ),

                ],
              ),

              const SizedBox(height: 20),

              /// RESUMEN
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Resumen Semanal",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    SizedBox(
                      height: 120,
                      child: Center(child: Text("Gráfica aquí")),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                "Apps restringidas",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),

              Expanded(

                child: appsRestringidas.isEmpty

                    ? const Center(child: Text("No hay apps restringidas"))

                    : ListView.builder(

                        itemCount: appsRestringidas.length,

                        itemBuilder: (_, index) {

                          final app = appsRestringidas[index];

                          return Container(

                            margin: const EdgeInsets.only(bottom: 10),

                            padding: const EdgeInsets.all(10),

                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                            ),

                            child: Row(

                              children: [

                                Image.asset(app.icono, width: 40),

                                const SizedBox(width: 10),

                                Expanded(child: Text(app.nombre)),

                                app.estaActiva

                                    ? const Text(
                                        "Activo",
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )

                                    : DropdownButton<int>(

                                        value: app.minutos == 0
                                            ? null
                                            : app.minutos,

                                        hint: const Text("Tiempo"),

                                        items: const [

                                          DropdownMenuItem(
                                            value: 5,
                                            child: Text("5 min"),
                                          ),

                                          DropdownMenuItem(
                                            value: 30,
                                            child: Text("30 min"),
                                          ),

                                          DropdownMenuItem(
                                            value: 60,
                                            child: Text("1 hora"),
                                          ),

                                        ],

                                        onChanged: (value) {

                                          setState(() {

                                            app.minutos = value!;
                                            app.tiempoInicio = DateTime.now();

                                          });

                                        },

                                      ),

                              ],

                            ),

                          );

                        },

                      ),

              ),

            ],

          ),

        ),

      ),

    );

  }

}