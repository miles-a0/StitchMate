import 'dart:async';
import 'dart:io';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import '../models/counter_adapter.dart';
import '../models/project_adapter.dart';
import '../models/yarn_adapter.dart';

/// Hive initialisation and box management.
///
/// Boxes are opened lazily — only required boxes are initialised at startup
/// to keep app launch under 2 seconds. Defer non-critical boxes.
///
/// Every Hive model must have its adapter registered here before [runApp()].
class HiveInit {
  HiveInit._();

  static const String _settingsBoxName = 'settings';
  static const String _projectsBoxName = 'projects';
  static const String _countersBoxName = 'counters';
  static const String _yarnBoxName = 'yarn';
  static const String _dictionaryBoxName = 'dictionary';
  static const String _timerBoxName = 'timer';

  static Box<dynamic>? _settingsBox;
  static Box<dynamic>? _projectsBox;
  static Box<dynamic>? _countersBox;
  static Box<dynamic>? _yarnBox;
  static Box<dynamic>? _dictionaryBox;
  static Box<dynamic>? _timerBox;

  /// Initialise Hive and open critical boxes.
  ///
  /// Call this in [main.dart] before [runApp()].
  static Future<void> initialise() async {
    if (Platform.isAndroid || Platform.isIOS || Platform.isMacOS) {
      final appDocumentDir = await getApplicationDocumentsDirectory();
      await Hive.initFlutter(appDocumentDir.path);
    } else {
      await Hive.initFlutter();
    }

    // Register Hive adapters.
    Hive.registerAdapter(CounterAdapter());
    Hive.registerAdapter(ProjectAdapter());
    Hive.registerAdapter(YarnAdapter());

    // Open critical boxes immediately (required for app launch).
    _settingsBox = await Hive.openBox<dynamic>(_settingsBoxName);
    _countersBox = await Hive.openBox<dynamic>(_countersBoxName);

    // Defer non-critical boxes to avoid blocking startup.
    unawaited(_openDeferredBoxes());
  }

  /// Open non-critical boxes asynchronously after app launch.
  static Future<void> _openDeferredBoxes() async {
    _projectsBox = await Hive.openBox<dynamic>(_projectsBoxName);
    _yarnBox = await Hive.openBox<dynamic>(_yarnBoxName);
    _dictionaryBox = await Hive.openBox<dynamic>(_dictionaryBoxName);
    _timerBox = await Hive.openBox<dynamic>(_timerBoxName);
  }

  // ── Box Accessors ──

  static Box<dynamic> get settingsBox {
    if (_settingsBox == null || !_settingsBox!.isOpen) {
      throw StateError(
        'Hive settings box is not open. Call HiveInit.initialise() first.',
      );
    }
    return _settingsBox!;
  }

  static Box<dynamic> get projectsBox {
    if (_projectsBox == null || !_projectsBox!.isOpen) {
      throw StateError(
        'Hive projects box is not open. Call HiveInit.initialise() first.',
      );
    }
    return _projectsBox!;
  }

  static Box<dynamic> get countersBox {
    if (_countersBox == null || !_countersBox!.isOpen) {
      throw StateError(
        'Hive counters box is not open. Call HiveInit.initialise() first.',
      );
    }
    return _countersBox!;
  }

  static Box<dynamic> get yarnBox {
    if (_yarnBox == null || !_yarnBox!.isOpen) {
      throw StateError(
        'Hive yarn box is not open. Call HiveInit.initialise() first.',
      );
    }
    return _yarnBox!;
  }

  static Box<dynamic> get dictionaryBox {
    if (_dictionaryBox == null || !_dictionaryBox!.isOpen) {
      throw StateError(
        'Hive dictionary box is not open. Call HiveInit.initialise() first.',
      );
    }
    return _dictionaryBox!;
  }

  static Box<dynamic> get timerBox {
    if (_timerBox == null || !_timerBox!.isOpen) {
      throw StateError(
        'Hive timer box is not open. Call HiveInit.initialise() first.',
      );
    }
    return _timerBox!;
  }

  /// Close all open boxes. Call on app termination if needed.
  static Future<void> closeAll() async {
    await _settingsBox?.close();
    await _projectsBox?.close();
    await _countersBox?.close();
    await _yarnBox?.close();
    await _dictionaryBox?.close();
    await _timerBox?.close();
  }
}
