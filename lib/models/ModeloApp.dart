import 'package:focusmode/models/requests/RestrictionCreateRequest.dart';
import 'package:focusmode/models/responses/RestrictionOutResponse.dart';

class ModeloApp {
  String appKey;
  String nombre;
  String icono;
  String plataforma;

  bool seleccionada;

  int minutos;

  DateTime? tiempoInicio;

  ModeloApp({
    required this.appKey,
    required this.nombre,
    required this.icono,
    required this.plataforma,
    this.seleccionada = false,
    this.minutos = 0,
    this.tiempoInicio,
  });

  factory ModeloApp.fromRestriction(RestrictionOutResponse restriction) {
    return ModeloApp(
      appKey: restriction.appKey,
      nombre: restriction.appName,
      icono: _resolveIconByKey(restriction.appKey),
      plataforma: restriction.platform,
      seleccionada: true,
      minutos: restriction.minutesLimit,
      tiempoInicio: restriction.startedAt,
    );
  }

  RestrictionCreateRequest toRestrictionCreateRequest() {
    return RestrictionCreateRequest(
      appKey: appKey,
      appName: nombre,
      platform: plataforma,
      minutesLimit: minutos <= 0 ? 30 : minutos,
      startedAt: tiempoInicio,
    );
  }

  bool get estaActiva {
    if (tiempoInicio == null) return false;

    final ahora = DateTime.now();

    final diferencia = ahora.difference(tiempoInicio!).inMinutes;

    return diferencia < minutos;
  }

  static String _resolveIconByKey(String appKey) {
    const iconByKey = {
      'tiktok': 'assets/imagenes/Tiktok.png',
      'instagram': 'assets/imagenes/Instagram.png',
      'whatsapp': 'assets/imagenes/Whatsapp.png',
      'facebook': 'assets/imagenes/Facebook.png',
    };

    return iconByKey[appKey] ?? 'assets/imagenes/icono.png';
  }
}
