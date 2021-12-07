import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:red_egresados/domain/models/publications.dart';
import 'package:get/get.dart';
import 'package:loggy/loggy.dart';
import 'authentication.dart';

class FirebaseController extends GetxController {
  var _records = <Publications>[].obs;
  final CollectionReference baby =
      FirebaseFirestore.instance.collection('baby');
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('baby').snapshots();
  late StreamSubscription<Object?> streamSubscription;
  final AuthController authController = Get.find();

  suscribeUpdates() async {
    logInfo('suscribeLocationUpdates');
    streamSubscription = _usersStream.listen((event) {
      logInfo('Got new item from fireStore');
      _records.clear();
      event.docs.forEach((element) {
        _records.add(Publications.fromSnapshot(element));
      });
      print('Got ${_records.length}');
    });
  }

  unsuscribeUpdates() {
    streamSubscription.cancel();
  }

  List<Publications> get entries => _records;

  addEntry(name) {
    baby
        .add({
          'name': name,
          'votes': 0,
          'user': authController.reactiveUser.value!.displayName ?? ""
        })
        .then((value) => print("Baby added"))
        .catchError((onError) => print("Failed to add baby $onError"));
  }

  updateEntry(Publications record) {
    record.reference.update({'votes': record.votes + 1});
  }

  deleteEntry(Publications record) {
    record.reference.delete();
  }
}