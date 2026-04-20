import 'dart:convert';

import 'package:focusmode/services/ApiService.dart';

class ApiErrorMapper {
  static String toFriendlyMessage(Object error) {
    if (error is! ApiException) {
      return 'No se pudo completar la solicitud. Intenta nuevamente.';
    }

    final detail = _extractDetail(error.responseBody);

    if (error.statusCode == 401) {
      return 'Tu sesion no es valida. Inicia sesion nuevamente.';
    }

    if (error.statusCode == 422) {
      if (detail != null && detail.isNotEmpty) {
        return detail;
      }
      return 'Revisa los datos ingresados e intenta de nuevo.';
    }

    if (error.statusCode >= 500) {
      return 'El servidor esta temporalmente no disponible. Intenta mas tarde.';
    }

    if (detail != null && detail.isNotEmpty) {
      return detail;
    }

    return 'No se pudo completar la solicitud (codigo ${error.statusCode}).';
  }

  static String? _extractDetail(String body) {
    try {
      final decoded = jsonDecode(body);

      if (decoded is Map<String, dynamic>) {
        final detail = decoded['detail'];

        if (detail is String) {
          return detail;
        }

        if (detail is List) {
          final messages = <String>[];

          for (final item in detail) {
            if (item is Map<String, dynamic>) {
              final msg = item['msg'];
              if (msg is String && msg.isNotEmpty) {
                messages.add(msg);
              }
            }
          }

          if (messages.isNotEmpty) {
            return messages.join('\n');
          }
        }
      }
    } catch (_) {}

    return null;
  }
}
