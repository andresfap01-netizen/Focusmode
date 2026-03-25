import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'AddApp.dart';
import 'ModeloApp.dart';

class PantallaPrincipal extends StatefulWidget {
  const PantallaPrincipal({super.key});

  @override
  State<PantallaPrincipal> createState() => _PantallaPrincipalState();
}

class _PantallaPrincipalState extends State<PantallaPrincipal> {

  List<ModeloApp> appsRestringidas = [];

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
                      height: 260,
                      child: Row(
                        children: const [
                          Expanded(
                            flex: 2,
                            child: Center(
                              child: _PieChartMock(
                                slices: [
                                  _PieSlice(
                                    label: "Titkok",
                                    value: 37,
                                    color: Color(0xFFc331f8),
                                  ),
                                  _PieSlice(
                                    label: "Instagram",
                                    value: 13.8,
                                    color: Color(0xFF4942ce),
                                  ),
                                  _PieSlice(
                                    label: "Whatsapp",
                                    value: 7.4,
                                    color: Color(0xFF2d8bba),
                                  ),
                                  _PieSlice(
                                    label: "Facebook",
                                    value: 14.8,
                                    color: Color(0xFF51a3b8),
                                  ),
                                  _PieSlice(
                                    label: "Youtube",
                                    value: 25.9,
                                    color: Color(0xFF66c5c4),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
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

class _PieSlice {
  // Modelo simple para cada segmento del pastel mockeado.
  final String label;
  final double value;
  final Color color;

  const _PieSlice({
    required this.label,
    required this.value,
    required this.color,
  });
}

class _PieChartMock extends StatelessWidget {
  // Lista de segmentos que se renderizan en el PieChart de fl_chart.
  final List<_PieSlice> slices;

  const _PieChartMock({required this.slices});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 110,
      height: 110,
      child: PieChart(
        PieChartData(
          // Espacio central para efecto dona.
          centerSpaceRadius: 40,
          sectionsSpace: 1,
          startDegreeOffset: -90,
          borderData: FlBorderData(show: false),
          // Secciones mock: cada item de slices se transforma en una porcion.
          sections: slices
              .map(
                (slice) => PieChartSectionData(
                  value: slice.value,
                  color: slice.color,
                  radius: 50,
                  title: "${slice.label}\n${slice.value.toInt()}%",
                  // El texto se muestra fuera del aro para mejorar lectura.
                  titleStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
                  titlePositionPercentageOffset: 1.7
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
