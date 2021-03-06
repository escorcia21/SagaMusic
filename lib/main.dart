import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saga_music/data/services/location.dart';
import 'package:saga_music/domain/use_cases/controllers/music_controller.dart';
import 'package:saga_music/domain/use_cases/location_management.dart';
import 'package:saga_music/ui/app.dart';
import 'package:workmanager/workmanager.dart';

import 'domain/models/location.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager().initialize(
    updatePositionInBackground,
    isInDebugMode: true,
  );
  Get.put(MusicController());
  runApp(const App());
}

void updatePositionInBackground() async {
  final manager = LocationManager();
  final service = LocationService();
  Workmanager().executeTask((task, inputData) async {
    final position = await manager.getCurrentLocation();
    final details = await manager.retrieveUserDetails();
    var location = MyLocation(
        name: details['name']!,
        id: details['uid']!,
        lat: position.latitude,
        long: position.longitude);
    await service.fecthData(
      map: location.toJson,
    );
    log("updated location background"); //simpleTask will be emitted here.
    print("updated location background"); //simpleTask will be emitted here.
    return Future.value(true);
  });
}
