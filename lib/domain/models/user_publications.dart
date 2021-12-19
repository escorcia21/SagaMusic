import 'package:cloud_firestore/cloud_firestore.dart';

class UserPublications {
  final String content;
  final String user;
  final String email;
  final String title;
  final DocumentReference reference;

  UserPublications.fromMap(Map<String, dynamic> map, {required this.reference})
      : assert(map['content'] != null),
        assert(map['user'] != null),
        assert(map['email'] != null),
        assert(map['title'] != null),
        content = map['content'],
        user = map['user'],
        email = map['email'],
        title = map['title'];

  UserPublications.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data() as Map<String, dynamic>,
            reference: snapshot.reference);

  @override
  String toString() => "Record<$user:$email>";
}
