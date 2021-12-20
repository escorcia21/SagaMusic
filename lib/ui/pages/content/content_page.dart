import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_egresados/domain/use_cases/controllers/authentication.dart';
import 'package:red_egresados/domain/use_cases/controllers/ui.dart';
import 'package:red_egresados/ui/pages/content/location/location_screen.dart';
import 'package:red_egresados/ui/pages/content/music/response_screen.dart';
//import 'package:red_egresados/ui/pages/content/music/widgets/song_card.dart';
import 'package:red_egresados/ui/pages/content/states/firestore_page.dart';
//import 'package:red_egresados/ui/pages/content/states/states_screen.dart';
//import 'package:red_egresados/ui/pages/content/users_offers/users_offers_screen.dart';
import 'package:red_egresados/ui/widgets/appbar.dart';

import 'chats/chat_page.dart';
import 'estados/firestore_publications.dart';

class ContentPage extends StatelessWidget {
  const ContentPage({Key? key}) : super(key: key);

// View content
  Widget _getScreen(int index) {
    switch (index) {
      case 1:
        return const ResponseScreen();
      case 2:
        return PublicationsPage();
      case 3:
        return LocationScreen();
      case 4:
        return ChatPage();
      default:
        return FireStorePage();
    }
  }

  // We create a Scaffold that is used for all the content pages
  // We only define one AppBar, and one scaffold.
  @override
  Widget build(BuildContext context) {
    // Dependency injection: State management controller
    final UIController controller = Get.find<UIController>();
    final AuthController authController = Get.find<AuthController>();

    return Scaffold(
      appBar: CustomAppBar(
        context: context,
        controller: controller,
        //picUrl: 'https://uifaces.co/our-content/donated/gPZwCbdS.jpg',
        // tile: const Text("Saga music"),
        tile: const Text("Saga Music"),
        onSignOff: () {
          authController.manager.signOut();
        },
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: Obx(() => _getScreen(controller.reactiveScreenIndex.value)),
          ),
        ),
      ),
      // Content screen navbar
      bottomNavigationBar: Obx(() => BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.add_comment_rounded,
                  key: Key("Estados"),
                ),
                label: 'Estados',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.music_note_sharp,
                  key: Key("Musica"),
                ),
                label: 'Musica',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.public_outlined,
                  key: Key("Publicaciones"),
                ),
                label: 'Publicaciones',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.place_outlined,
                  key: Key("Ubicación"),
                ),
                label: 'Ubicación',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.chat_bubble_outline,
                  key: Key("Mensajes"),
                ),
                label: 'Mensajes',
              ),
            ],
            currentIndex: controller.screenIndex,
            onTap: (index) {
              controller.screenIndex = index;
            },
          )),
    );
  }
}
