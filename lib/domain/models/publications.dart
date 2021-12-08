import 'package:cloud_firestore/cloud_firestore.dart';

class Publications {
  final String content;
  final String user;
  final String userName;
  final int favorites;
  final DocumentReference reference;

  Publications.fromMap(Map<String, dynamic> map, {required this.reference})
      : assert(map['content'] != null),
        assert(map['user'] != null),
        assert(map['userName'] != null),
        assert(map['favorites'] != null),
        content = map['content'],
        favorites = map['favorites'],
        user = map['user'],
        userName = map['userName'];

  Publications.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data() as Map<String, dynamic>,
            reference: snapshot.reference);

  @override
  String toString() => "Record<$user:$favorites:$content>";
}
