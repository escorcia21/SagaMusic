import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:saga_music/domain/models/message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:loggy/loggy.dart';

class ChatController extends GetxController {
  final databaseReference = FirebaseDatabase.instance.reference();
  var messages = <Message>[].obs;
  late StreamSubscription<Event> newEntryStreamSubscription;
  late StreamSubscription<Event> updateEntryStreamSubscription;

  //Método start para comenzar a escuchar la colección de documentos FlutterMessages,
  //que contiene el mensaje a enviar en los chats
  start() {
    messages.clear();
    newEntryStreamSubscription = databaseReference
        .child("fluttermessages")
        .onChildAdded
        .listen(_onEntryAdded);

    updateEntryStreamSubscription = databaseReference
        .child("fluttermessages")
        .onChildChanged
        .listen(_onEntryChanged);
  }

  stop() {
    newEntryStreamSubscription.cancel();
    updateEntryStreamSubscription.cancel();
  }

  _onEntryChanged(Event event) {
    print("Something was changed");
    var oldEntry = messages.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });
    messages[messages.indexOf(oldEntry)] = Message.fromSnapshot(event.snapshot);
  }

  _onEntryAdded(Event event) {
    print("Something was added");
    messages.add(Message.fromSnapshot(event.snapshot));
  }

  //Método sendmsg para enviar un nuevo mensaje
  Future<void> sendMsg(String text) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    try {
      databaseReference
          .child("fluttermessages")
          .push()
          .set({'text': text, 'uid': uid});
    } catch (error) {
      logError("Error sending msg $error");
      return Future.error(error);
    }
  }

  Future<void> updateMsg(Message message) async {
    logInfo('updateMsg with key ${message.key}');
    try {
      databaseReference
          .child("fluttermessages")
          .child(message.key)
          .set({'text': 'updated ' + message.text, 'uid': message.user});
    } catch (error) {
      logError("Error updating msg $error");
      return Future.error(error);
    }
  }

  Future<void> deleteMsg(Message message, int index) async {
    logInfo('deleteMsg with key ${message.key}');
    try {
      databaseReference
          .child("fluttermessages")
          .child(message.key)
          .remove()
          .then((value) => messages.removeAt(index));
    } catch (error) {
      logError("Error deleting msg $error");
      return Future.error(error);
    }
  }
}
