import 'package:flutter/material.dart';
import 'package:quiz_backoffice/constants/style.dart';
import 'package:quiz_backoffice/helpers/reponsiveness.dart';

import 'custom_text.dart';

AppBar topNavigationBar(BuildContext context, GlobalKey<ScaffoldState> key) =>
    AppBar(
      leading: !ResponsiveWidget.isSmallScreen(context)
          ? Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Image.asset(
                    "assets/icons/logo.png",
                    width: 28,
                  ),
                ),
              ],
            )
          : IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                key.currentState?.openDrawer();
              }),
      title: Row(
        children: [
          Visibility(
            visible: !ResponsiveWidget.isSmallScreen(context),
            child: const CustomText(
              text: "EarthWise",
              color: lightGrey,
              size: 20,
              weight: FontWeight.bold,
            ),
          ),
          Expanded(child: Container()),
          IconButton(
            icon: const Icon(
              Icons.settings,
              color: dark,
            ),
            onPressed: () {
              // Handle settings button press
              // You can show a dialog or navigate to the settings page
            },
          ),
          Stack(
            children: [
              IconButton(
                icon: Icon(
                  Icons.notifications,
                  color: dark.withOpacity(.7),
                ),
                onPressed: () {
                  // Handle notifications button press
                  // You can show a notifications panel or navigate to notifications
                },
              ),
              Positioned(
                top: 7,
                right: 7,
                child: Container(
                  width: 12,
                  height: 12,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: active,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: light, width: 2),
                  ),
                ),
              ),
            ],
          ),
          Container(
            width: 1,
            height: 22,
            color: lightGrey,
          ),
          const SizedBox(
            width: 24,
          ),
          const CustomText(
            text: "Ayachi Zakaria",
            color: lightGrey,
          ),
          const SizedBox(
            width: 16,
          ),
          InkWell(
            onTap: () {
              // Handle image click, e.g., show profile settings menu
              print('Image Clicked');
              showProfileMenu(context);
            },
            child: ClipOval(
              child: Image.asset(
                'assets/images/profile.jpg',
                width: 40, // Adjust the width as needed
                height: 40, // Adjust the height as needed
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
      iconTheme: const IconThemeData(color: dark),
      elevation: 0,
      backgroundColor: const Color.fromARGB(0, 0, 0, 0),
    );

void showProfileMenu(BuildContext context) {
  showMenu(
    context: context,
    position: RelativeRect.fromLTRB(100, 100, 0, 0),
    items: [
      PopupMenuItem(
        child: ListTile(
          leading: Icon(Icons.person),
          title: Text('Profile'),
        ),
      ),
      PopupMenuItem(
        child: ListTile(
          leading: Icon(Icons.settings),
          title: Text('Settings'),
        ),
      ),
    ],
  );
}
