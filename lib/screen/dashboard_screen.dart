import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/user.dart';
import '../provider/auth_provider.dart';
import '../widgets/dashboard_tile.dart';
import 'all_incident.dart';
import 'login_screen.dart';
import 'my_incident_screen.dart';

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

  bool _checkRoles() {
    List<Roles> roles = Provider.of<AuthProvider>(context, listen: false).roles;
    bool isManager = false;

    for (var element in roles) {
      isManager = (element.name!.toLowerCase().contains("manager") ||
              element.name!.toLowerCase().contains("admin"))
          ? true
          : false;
    }

    return isManager;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  DashboardTile(
                      title: "Incident\nReporting",
                      iconData: Ionicons.warning_outline,
                      function: () {
                        _checkRoles()
                            ? showPopUpMenu()
                            : Navigator.of(context)
                                .pushNamed(MyIncidentScreen.routeName);
                      }),
                  DashboardTile(
                      title: "Gate\nPass",
                      iconData: Icons.garage_outlined,
                      function: () {
                        Fluttertoast.showToast(msg: "Gate Pass");
                      }),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  DashboardTile(
                      title: "JPM",
                      iconData: Icons.account_balance_sharp,
                      function: () {
                        Fluttertoast.showToast(msg: "JPM");
                      }),
                  DashboardTile(
                    title: "Work\nPermit",
                    iconData: Icons.work,
                    function: () => Fluttertoast.showToast(msg: "Work Permit"),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  DashboardTile(
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
      ),
    );
  }

  showPopUpMenu() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    child: Text(
                      'My incident',
                      style: Theme.of(context).textTheme.headline6!.merge(
                            const TextStyle(color: Colors.white),
                          ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.of(context)
                          .pushNamed(MyIncidentScreen.routeName);
                    },
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: OutlinedButton(
                    child: Text(
                      'All incident',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.of(context).pushNamed(AllIncident.routeName);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
