import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:saga_music/domain/models/publications.dart';
import 'package:get/get.dart';
import 'package:loggy/loggy.dart';
import 'package:saga_music/domain/models/user_publications.dart';
import 'authentication.dart';

class FirebasePublicationsController extends GetxController {
  var _records = <UserPublications>[].obs;
  final CollectionReference baby =
      FirebaseFirestore.instance.collection('publications');
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('publications').snapshots();
  late StreamSubscription<Object?> streamSubscription;
  final AuthController authController = Get.find();

  suscribeUpdates() async {
    logInfo('suscribeLocationUpdates');
    streamSubscription = _usersStream.listen((event) {
      logInfo('Got new item from fireStore');
      _records.clear();
      event.docs.forEach((element) {
        _records.add(UserPublications.fromSnapshot(element));
      });
      print('Got ${_records.length}');
    });
  }

  unsuscribeUpdates() {
    streamSubscription.cancel();
  }

  List<UserPublications> get entries => _records;

  addEntry(name, title) {
    baby
        .add({
          'content': name,
          'user': authController.reactiveUser.value!.uid,
          'email': authController.reactiveUser.value!.email,
          'title': title,
        })
        .then((value) => print("Baby added"))
        .catchError((onError) => print("Failed to add baby $onError"));
  }

  deleteEntry(Publications record) {
    record.reference.delete();
  }
}
