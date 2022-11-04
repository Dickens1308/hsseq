import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hsseq/screen/IncidentScreen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  static const routeName = '/dashboard';

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 60),
            Row(
              children: [
                ContainerScreen(
                    title: "Incident\nReport",
                    iconData: Icons.home,
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
        height: MediaQuery.of(context).size.height * .2,
        width: MediaQuery.of(context).size.width * .4,
        margin: const EdgeInsets.only(left: 15, right: 15),
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
            const SizedBox(height: 20),
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
