import 'package:doan_along/util/constain.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: kPrimaryMainColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: kPrimaryGreenColor,
            ),
            child: Center(child: Text('Hải Long - D18DCDT131')),
          ),
          ListTile(
            title: const Text('Home'),
            onTap: () {
              if (Get.currentRoute != '/home') {
                Get.offAllNamed('/home');
              }
            },
          ),
          ListTile(
            title: const Text('Controller'),
            onTap: () {
              if (Get.currentRoute != '/setting') {
                Get.offAllNamed('/setting');
              }
            },
          ),
          ListTile(
            title: const Text('Credits'),
            onTap: () {
              if (Get.currentRoute != '/credits') {
                Get.offAllNamed('/credits');
              }
            },
          ),
        ],
      ),
    );
  }
}
