class ModeloApp{

  String nombre;
  String icono;

  bool seleccionada;

  int minutos;

  DateTime? tiempoInicio;

  ModeloApp({
    required this.nombre,
    required this.icono,
    this.seleccionada = false,
    this.minutos = 0,
    this.tiempoInicio,
  });

  bool get estaActiva{

    if(tiempoInicio == null) return false;

    final ahora = DateTime.now();

    final diferencia = ahora.difference(tiempoInicio!).inMinutes;

    return diferencia < minutos;

  }

}