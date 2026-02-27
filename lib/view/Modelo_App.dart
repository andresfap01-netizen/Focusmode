class Modelo_App{

  String nombre;
  String icono;

  bool seleccionada;

  int minutos;

  DateTime? tiempoInicio;

  Modelo_App({
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