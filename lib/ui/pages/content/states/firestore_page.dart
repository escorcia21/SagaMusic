import 'package:red_egresados/domain/models/publications.dart';
import 'package:red_egresados/domain/use_cases/controllers/firestore_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prompt_dialog/prompt_dialog.dart';
import 'package:red_egresados/ui/pages/content/states/widgets/new_state.dart';
import 'package:red_egresados/ui/theme/colors.dart';

class FireStorePage extends StatefulWidget {
  @override
  State<FireStorePage> createState() => _FireStorePageState();
}

class _FireStorePageState extends State<FireStorePage> {
  final FirebaseController firebaseController = Get.find();

  @override
  void initState() {
    firebaseController.suscribeUpdates();
    super.initState();
  }

  @override
  void dispose() {
    firebaseController.unsuscribeUpdates();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Obx(
          () => ListView.builder(
              itemCount: firebaseController.entries.length,
              padding: EdgeInsets.only(top: 20.0),
              itemBuilder: (BuildContext context, int index) {
                return _buildItem(context, firebaseController.entries[index]);
              }),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          backgroundColor: AppColors.primaryColor,
          onPressed: () {
            addBaby(context);
          },
        ));
  }

  Widget _buildItem(BuildContext context, Publications record) {
    return Padding(
      key: ValueKey(record.user),
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ListTile(
            title: Text(record.userName),
            subtitle: Text(record.content),
            trailing: Text(record.favorites.toString()),
            onTap: () => firebaseController.updateEntry(record),
            onLongPress: () => firebaseController.deleteEntry(record)),
      ),
    );
  }

  Future<void> addBaby(BuildContext context) async {
    getName(context).then((value) {
      firebaseController.addEntry(value);
    });
  }

  Future<String> getName(BuildContext context) async {
    String? result = await prompt(
      context,
      title: Text('Agrega un estado'),
      initialValue: '',
      textOK: Text('Ok'),
      textCancel: Text('Cancel'),
      hintText: 'Escribe aquí',
      validator: (value) {
        if (value!.isEmpty) {
          return 'Por favor ingresar algo';
        } else if (value.length > 150) {
          return 'Texto muy largo,\ndebe tener menos de\n150 caracteres.\nfueron ingresados: ${value.length}';
        }
        return null;
      },
      minLines: 1,
      maxLines: 7,
      autoFocus: true,
      obscureText: false,
      textCapitalization: TextCapitalization.words,
    );
    if (result != null) {
      return Future.value(result);
    }
    return Future.error('cancel');
  }
}
