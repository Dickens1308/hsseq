// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:hsseq/model/incident.dart';
import 'package:hsseq/provider/incident_provider.dart';
import 'package:hsseq/screen/login_screen.dart';
import 'package:hsseq/screen/my_incident_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AllIncident extends StatefulWidget {
  const AllIncident({Key? key}) : super(key: key);

  static const routeName = '/all_incident';

  @override
  State<AllIncident> createState() => _AllIncidentState();
}

class _AllIncidentState extends State<AllIncident> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<IncidentProvider>(context, listen: false).fetchAllIncident();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Incident"),
      ),
      body: Consumer<IncidentProvider>(
        builder: (context, provider, child) {
          return provider.isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: provider.incidentList.length,
                          itemBuilder: (ctx, i) {
                            Incident incident = provider.incidentList[i];

                            return IncidentListTile(
                              incident: incident,
                              parentChild: 'all_incident',
                            );
                          })
                    ],
                  ),
                );
        },
      ),
    );
  }

  saveTokenPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove("token");

    // ignore: use_build_context_synchronously
    Navigator.of(context)
        .pushNamedAndRemoveUntil(LoginScreen.routeName, (route) => false);
  }
}
