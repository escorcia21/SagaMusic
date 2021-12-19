import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prompt_dialog/prompt_dialog.dart';
import 'package:red_egresados/domain/models/publications.dart';
import 'package:red_egresados/domain/models/user_publications.dart';
import 'package:red_egresados/domain/use_cases/controllers/firestore_publications.dart';
import 'package:red_egresados/ui/pages/content/estados/widgets/publication_card.dart';
import 'package:red_egresados/ui/theme/colors.dart';

class PublicationsPage extends StatefulWidget {
  @override
  State<PublicationsPage> createState() => _PublicationsPage();
}

class _PublicationsPage extends State<PublicationsPage> {
  final FirebasePublicationsController firebaseController = Get.find();

  late TextEditingController publicationController;
  late TextEditingController titleController;

  @override
  void initState() {
    firebaseController.suscribeUpdates();
    publicationController = TextEditingController();
    titleController = TextEditingController();
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
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
          backgroundColor: AppColors.primaryColor,
          onPressed: () {
            Get.dialog(form(context));
          },
        ));
  }

  Widget _buildItem(BuildContext context, UserPublications record) {
    return PunlicationCard(
      content: record.content,
      title: record.title,
      email: record.email,
    );
  }

  // Future<void> addBaby(BuildContext context) async {
  //   getName(context).then((value) {
  //     firebaseController.addEntry(value);
  //   });
  // }

  // Future<String> getName(BuildContext context) async {
  //   String? result = await prompt(
  //     context,
  //     title: Text('Agrega un estado'),
  //     initialValue: '',
  //     textOK: Text('Ok'),
  //     textCancel: Text('Cancel'),
  //     hintText: 'Escribe aquí',
  //     validator: (value) {
  //       if (value!.isEmpty) {
  //         return 'Por favor ingresar algo';
  //       } else if (value.length > 350) {
  //         return 'Texto muy largo,\ndebe tener menos de\n150 caracteres.\nfueron ingresados: ${value.length}';
  //       }
  //       return null;
  //     },
  //     minLines: 1,
  //     maxLines: 7,
  //     autoFocus: true,
  //     obscureText: false,
  //     textCapitalization: TextCapitalization.words,
  //   );

  //   String? result1 = await prompt(
  //     context,
  //     title: Text('Agrega un estado'),
  //     initialValue: '',
  //     textOK: Text('Ok'),
  //     textCancel: Text('Cancel'),
  //     hintText: 'Escribe aquí',
  //     validator: (value) {
  //       if (value!.isEmpty) {
  //         return 'Por favor ingresar algo';
  //       } else if (value.length > 350) {
  //         return 'Texto muy largo,\ndebe tener menos de\n150 caracteres.\nfueron ingresados: ${value.length}';
  //       }
  //       return null;
  //     },
  //     minLines: 1,
  //     maxLines: 7,
  //     autoFocus: true,
  //     obscureText: false,
  //     textCapitalization: TextCapitalization.words,
  //   );

  //   if (result != null) {
  //     return Future.value(result);
  //   }
  //   return Future.error('cancel');
  // }

  Widget form(BuildContext context) {
    // Description of the action that we are performing
    const _dialogAction = "Publicar";

    return Dialog(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Titulo",
              style: Theme.of(context).textTheme.headline2,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: TextField(
                key: const Key("titulo"),
                controller: titleController,
                keyboardType: TextInputType.multiline,
                // dynamic text lines
                maxLines: null,
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
            ),
            Text(
              "Mensaje",
              style: Theme.of(context).textTheme.headline2,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: TextField(
                controller: publicationController,
                keyboardType: TextInputType.multiline,
                // dynamic text lines
                maxLines: 4,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: ElevatedButton(
                    child: const Text(_dialogAction),
                    onPressed: () => {
                      // If userJob is null, this means that this offer is new; otherwise,
                      // it means that we are updating a previous one.
                      if (publicationController.text != "" &&
                          titleController.text != "")
                        {
                          firebaseController.addEntry(
                              publicationController.text, titleController.text),
                          publicationController.clear(),
                          titleController.clear(),
                          Navigator.pop(context, false)
                        }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
