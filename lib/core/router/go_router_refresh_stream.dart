import 'dart:async';

import 'package:flutter/foundation.dart';

/// Faz o GoRouter reavaliar o `redirect` a cada emissão do Stream (ex.: AuthBloc).
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _sub = stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _sub;

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}
