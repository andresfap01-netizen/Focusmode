import 'package:focusmode/models/requests/RestrictionCreateRequest.dart';

class RestrictionSyncRequest {
  final List<RestrictionCreateRequest> restrictions;

  const RestrictionSyncRequest({required this.restrictions});

  Map<String, dynamic> toJson() {
    return {'restrictions': restrictions.map((item) => item.toJson()).toList()};
  }
}
