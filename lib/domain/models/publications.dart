import 'package:cloud_firestore/cloud_firestore.dart';

class Publications {
  final String name;
  final String user;
  final int votes;
  final DocumentReference reference;

  Publications.fromMap(Map<String, dynamic> map, {required this.reference})
      : assert(map['name'] != null),
        assert(map['votes'] != null),
        assert(map['user'] != null),
        name = map['name'],
        votes = map['votes'],
        user = map['user'];

  Publications.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data() as Map<String, dynamic>,
            reference: snapshot.reference);

  @override
  String toString() => "Record<$name:$votes>";
}
