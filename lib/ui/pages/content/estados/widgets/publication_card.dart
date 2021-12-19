import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:red_egresados/ui/widgets/card.dart';

class PunlicationCard extends StatelessWidget {
  final String title, content, email;

  // OfferCard constructor
  const PunlicationCard(
      {Key? key,
      required this.title,
      required this.content,
      required this.email})
      : super(key: key);

  // We create a Stateless widget that contais an AppCard,
  // Passing all the customizable views as parameters
  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).colorScheme.primary;
    return AppCard(
      key: const Key("offerCard"),
      title: title,
      content: Text(
        content,
        style: Theme.of(context).textTheme.bodyText1,
      ),
      // topRightWidget widget as an IconButton
      topRightWidget: IconButton(
        icon: Icon(
          Icons.copy_outlined,
          color: primaryColor,
        ),
        onPressed: () {
          Clipboard.setData(ClipboardData(text: content));
          Get.showSnackbar(
            GetBar(
              message: "Se ha copiado la publicacion al portapapeles.",
              duration: const Duration(seconds: 2),
            ),
          );
        },
      ),
      // extraContent widget as a column that contains more details about the offer
      // and an extra action (onApply)
      extraContent: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Icon(
                  Icons.email,
                  color: primaryColor,
                ),
              ),
              Text(
                email,
                style: Theme.of(context).textTheme.caption,
              ),
            ],
          ),
          const SizedBox(
            height: 8.0,
          ),
        ],
      ),
    );
  }
}
