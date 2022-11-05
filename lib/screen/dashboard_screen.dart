// ignore_for_file: depend_on_referenced_packages

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hsseq/model/user.dart';
import 'package:hsseq/provider/auth_provider.dart';
import 'package:hsseq/screen/incident_screen.dart';
import 'package:hsseq/screen/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ionicons/ionicons.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  static const routeName = '/dashboard';

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<AuthProvider>(context, listen: false).checkUserOffline();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  Provider.of<AuthProvider>(context).user.name.toString(),
                  style: Theme.of(context).textTheme.headline6!.merge(
                        const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                ),
                Text(
                  Provider.of<AuthProvider>(context)
                      .roles
                      .first
                      .name
                      .toString(),
                  style: Theme.of(context).textTheme.bodyText1!.merge(
                        const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                ),
              ],
            ),
          ),
          CircleAvatar(
            radius: 30,
            backgroundColor: Theme.of(context).primaryColor.withOpacity(.6),
            child: Text(
              Provider.of<AuthProvider>(context)
                  .user
                  .name
                  .toString()
                  .substring(0, 2),
              style: Theme.of(context).textTheme.headline5!.merge(
                    const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
            ),
          ),
          const SizedBox(width: 15)
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 60),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ContainerScreen(
                    title: "Incident\nReport",
                    iconData: Ionicons.bar_chart_outline,
                    function: () {
                      Navigator.of(context).pushNamed(IncidentScreen.routeName);
                    }),
                ContainerScreen(
                    title: "Gate\nPass",
                    iconData: Icons.home,
                    function: () {
                      Fluttertoast.showToast(msg: "Gate Pass");
                    }),
              ],
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ContainerScreen(
                    title: "JPM",
                    iconData: Icons.home,
                    function: () {
                      Fluttertoast.showToast(msg: "JPM");
                    }),
                ContainerScreen(
                    title: "Work\nPermit",
                    iconData: Icons.home,
                    function: () {
                      Fluttertoast.showToast(msg: "Work Permit");
                    }),
              ],
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ContainerScreen(
                    title: "Logout",
                    iconData: Ionicons.log_out_outline,
                    function: () async {
                      SharedPreferences pref =
                          await SharedPreferences.getInstance();
                      pref.remove("token").then((value) => {
                            Navigator.pushNamedAndRemoveUntil(context,
                                LoginScreen.routeName, (route) => false)
                          });
                    }),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .4,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class ContainerScreen extends StatelessWidget {
  const ContainerScreen(
      {Key? key,
      required this.title,
      required this.iconData,
      required this.function})
      : super(key: key);
  final String title;
  final IconData iconData;
  final Function function;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => function(),
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: MediaQuery.of(context).size.height * .22,
        width: MediaQuery.of(context).size.width * .4,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              spreadRadius: .4,
              blurRadius: .4,
              offset: const Offset(1, 0),
              color: const Color.fromARGB(255, 179, 179, 179).withOpacity(.3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              child: Icon(iconData, color: Colors.blue, size: 35),
            ),
            const SizedBox(height: 14),
            Text(
              title,
              style: Theme.of(context).textTheme.headline6,
            ),
          ],
        ),
      ),
    );
  }
}
