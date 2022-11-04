// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:hsseq/model/incident.dart';
import 'package:hsseq/provider/incident_provider.dart';
import 'package:hsseq/screen/login_screen.dart';
import 'package:hsseq/screen/view_incident.dart';
import 'package:intl/intl.dart';
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

                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            ViewIncident(incident: incident)));
                              },
                              behavior: HitTestBehavior.opaque,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 15, right: 15, top: 15),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        spreadRadius: .4,
                                        blurRadius: .4,
                                        offset: const Offset(1, 0),
                                        color: const Color.fromARGB(
                                                255, 179, 179, 179)
                                            .withOpacity(.3),
                                      ),
                                    ],
                                  ),
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor:
                                          Colors.blue.withOpacity(.1),
                                      radius: 20,
                                      child: const Icon(
                                        Icons.ac_unit_outlined,
                                        color: Colors.blue,
                                      ),
                                    ),
                                    title: Text(
                                      incident.location.toString(),
                                      style:
                                          Theme.of(context).textTheme.headline6,
                                    ),
                                    subtitle: Padding(
                                      padding: const EdgeInsets.only(top: 6),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            DateFormat('MMM d, yyyy').format(
                                                DateTime.parse(incident
                                                    .createdAt
                                                    .toString())),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1!
                                                .merge(
                                                  const TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.grey,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                          ),
                                          const SizedBox(width: 3),
                                          Container(
                                            margin: const EdgeInsets.only(
                                                bottom: 2),
                                            height: 10,
                                            width: 2,
                                            color: Colors.blue,
                                          ),
                                          const SizedBox(width: 3),
                                          Text(
                                            incident.riskLevel.toString(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1!
                                                .merge(
                                                  TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    color: incident.riskLevel
                                                                .toString()
                                                                .toLowerCase() ==
                                                            "high"
                                                        ? Colors.red
                                                        : (incident.riskLevel
                                                                    .toString()
                                                                    .toLowerCase() ==
                                                                "medium"
                                                            ? Colors.green
                                                            : Colors.grey),
                                                    fontSize: 12,
                                                  ),
                                                ),
                                          ),
                                          const SizedBox(width: 3),
                                          Container(
                                            margin: const EdgeInsets.only(
                                                bottom: 2),
                                            height: 10,
                                            width: 2,
                                            color: Colors.blue,
                                          ),
                                          const SizedBox(width: 3),
                                          Text(
                                            incident.isViewed.toString() == "1"
                                                ? "Viewed"
                                                : "Not Viewed",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1!
                                                .merge(
                                                  const TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.grey,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    trailing: IconButton(
                                      icon: const Icon(
                                        Icons.arrow_forward_ios,
                                        size: 18,
                                        color: Colors.blue,
                                      ),
                                      onPressed: () {},
                                    ),
                                  ),
                                ),
                              ),
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
