import 'dart:async';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:focusmode/models/ModeloApp.dart';
import 'package:focusmode/models/requests/RestrictionPatchRequest.dart';
import 'package:focusmode/models/requests/RestrictionSyncRequest.dart';
import 'package:focusmode/services/ApiErrorMapper.dart';
import 'package:focusmode/models/responses/WeeklyStatItemResponse.dart';
import 'package:focusmode/services/ApiService.dart';
import 'package:focusmode/ui/AppToast.dart';
import 'package:focusmode/views/AddApp.dart';

class PantallaPrincipal extends StatefulWidget {
  const PantallaPrincipal({super.key});

  @override
  State<PantallaPrincipal> createState() => _PantallaPrincipalState();
}

class _PantallaPrincipalState extends State<PantallaPrincipal> {
  final ApiService _apiService = ApiService();

  List<ModeloApp> appsRestringidas = [];
  List<_PieSlice> _statsSlices = const [];
  int _weekTotalMinutes = 0;
  bool _isLoading = true;

  Timer? timer;

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {});
    });

    _loadInitialData();
  }

  @override
  void dispose() {
    timer?.cancel();

    super.dispose();
  }

  void abrirAddApp() async {
    final resultado = await Navigator.push<List<ModeloApp>>(
      context,
      MaterialPageRoute(
        builder: (_) => AddApp(appsSeleccionadas: appsRestringidas),
      ),
    );

    if (resultado != null) {
      setState(() {
        appsRestringidas = resultado;
      });

      await _syncRestrictions();
    }
  }

  Future<void> _loadInitialData() async {
    try {
      final restrictionsFuture = _apiService.getRestrictions();
      final weeklyStatsFuture = _apiService.getWeeklyStats();

      final restrictions = await restrictionsFuture;
      final weeklyStats = await weeklyStatsFuture;

      if (!mounted) {
        return;
      }

      setState(() {
        appsRestringidas = restrictions
            .map((item) => ModeloApp.fromRestriction(item))
            .toList();

        _weekTotalMinutes = weeklyStats.weekTotalMinutes;
        _statsSlices = _buildSlicesFromStats(weeklyStats.items);
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
      });

      AppToast.showError(context, ApiErrorMapper.toFriendlyMessage(error));
    }
  }

  Future<void> _syncRestrictions() async {
    try {
      final request = RestrictionSyncRequest(
        restrictions: appsRestringidas
            .map((app) => app.toRestrictionCreateRequest())
            .toList(),
      );

      final synced = await _apiService.syncRestrictions(request);

      if (!mounted) {
        return;
      }

      setState(() {
        appsRestringidas = synced
            .map((restriction) => ModeloApp.fromRestriction(restriction))
            .toList();
      });

      await _reloadWeeklyStats();
    } catch (error) {
      if (!mounted) {
        return;
      }

      AppToast.showError(context, ApiErrorMapper.toFriendlyMessage(error));
    }
  }

  Future<void> _updateRestrictionMinutes(ModeloApp app, int minutes) async {
    final previousMinutes = app.minutos;
    final previousStart = app.tiempoInicio;

    setState(() {
      app.minutos = minutes;
      app.tiempoInicio = DateTime.now();
    });

    try {
      await _apiService.updateRestriction(
        app.appKey,
        RestrictionPatchRequest(
          minutesLimit: app.minutos,
          startedAt: app.tiempoInicio,
        ),
      );

      await _reloadWeeklyStats();
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        app.minutos = previousMinutes;
        app.tiempoInicio = previousStart;
      });

      final message = ApiErrorMapper.toFriendlyMessage(error);
      AppToast.showError(
        context,
        'No se pudo actualizar ${app.nombre}.\n$message',
      );
    }
  }

  List<_PieSlice> _buildSlicesFromStats(List<WeeklyStatItemResponse> items) {
    const palette = [
      Color(0xFFc331f8),
      Color(0xFF4942ce),
      Color(0xFF2d8bba),
      Color(0xFF51a3b8),
      Color(0xFF66c5c4),
    ];

    if (items.isEmpty) {
      return const [];
    }

    return List.generate(items.length, (index) {
      final item = items[index];
      return _PieSlice(
        label: item.appName,
        value: item.percentage,
        color: palette[index % palette.length],
      );
    });
  }

  Future<void> _reloadWeeklyStats() async {
    try {
      final weeklyStats = await _apiService.getWeeklyStats();

      if (!mounted) {
        return;
      }

      setState(() {
        _weekTotalMinutes = weeklyStats.weekTotalMinutes;
        _statsSlices = _buildSlicesFromStats(weeklyStats.items);
      });
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

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

                  Container(
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
                ],
              ),

              const SizedBox(height: 20),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Resumen Semanal",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Total semanal: $_weekTotalMinutes min",
                      style: const TextStyle(color: Colors.black54),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 260,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Center(
                              child: _PieChartMock(slices: _statsSlices),
                            ),
                          ),
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
                                          if (value == null) {
                                            return;
                                          }
                                          _updateRestrictionMinutes(app, value);
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
  final List<_PieSlice> slices;

  const _PieChartMock({required this.slices});

  @override
  Widget build(BuildContext context) {
    if (slices.isEmpty) {
      return const Center(
        child: Text(
          'Sin datos semanales',
          style: TextStyle(color: Colors.black54),
        ),
      );
    }

    return SizedBox(
      width: 110,
      height: 110,
      child: PieChart(
        PieChartData(
          centerSpaceRadius: 40,
          sectionsSpace: 1,
          startDegreeOffset: -90,
          borderData: FlBorderData(show: false),
          sections: slices
              .map(
                (slice) => PieChartSectionData(
                  value: slice.value,
                  color: slice.color,
                  radius: 50,
                  title: "${slice.label}\n${slice.value.toInt()}%",
                  titleStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  titlePositionPercentageOffset: 1.7,
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
