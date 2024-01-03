import 'package:flutter/material.dart';
import 'package:quiz_backoffice/constants/controllers.dart';
import 'package:quiz_backoffice/helpers/reponsiveness.dart';
import 'package:quiz_backoffice/pages/clients/widgets/clients_table.dart';
import 'package:quiz_backoffice/widgets/custom_text.dart';
import 'package:get/get.dart';

class ClientsPage extends StatelessWidget {
  const ClientsPage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
         return Column(
         children: [
          Obx(() => Row(
             children: [
               Container(
                 margin: EdgeInsets.only(top:
                 ResponsiveWidget.isSmallScreen(context) ? 56 : 6),
                 child: CustomText(text: menuController.activeItem.value, size: 24, weight: FontWeight.bold,)),
             ],
           ),),

           Expanded(child: ListView(
             children: const [
               Clientstable(),
             ],
           )),

           ],
         );
  }
}