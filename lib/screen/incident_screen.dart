import 'package:flutter/material.dart';
import 'package:hsseq/screen/all_incident.dart';
import 'package:hsseq/screen/my_incident_screen.dart';

class IncidentScreen extends StatefulWidget {
  const IncidentScreen({Key? key}) : super(key: key);

  static const routeName = '/incident';

  @override
  State<IncidentScreen> createState() => _IncidentScreenState();
}

class _IncidentScreenState extends State<IncidentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Incidents"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ContainerScreen(
            title: "My Incidence",
            iconData: Icons.ac_unit_outlined,
            function: () {
              Navigator.of(context).pushNamed(MyIncidentScreen.routeName);
            },
          ),
          ContainerScreen(
            title: "All Incidences",
            iconData: Icons.account_tree_outlined,
            function: () {
              Navigator.of(context).pushNamed(AllIncident.routeName);
            },
          ),
        ],
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
        height: MediaQuery.of(context).size.height * .1,
        width: MediaQuery.of(context).size.width * .8,
        margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 35),
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              radius: 24,
              child: Icon(
                iconData,
                color: Colors.blue.shade300,
                size: 28,
              ),
            ),
            const SizedBox(width: 20),
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
