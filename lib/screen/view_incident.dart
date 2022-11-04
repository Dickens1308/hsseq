import 'package:flutter/material.dart';
import 'package:hsseq/model/incident.dart';

class ViewIncident extends StatefulWidget {
  const ViewIncident({Key? key, required this.incident}) : super(key: key);

  final Incident incident;

  @override
  State<ViewIncident> createState() => _ViewIncidentState();
}

class _ViewIncidentState extends State<ViewIncident> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Incident Details"),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:const [

          ],
        ),
      ),
    );
  }
}
