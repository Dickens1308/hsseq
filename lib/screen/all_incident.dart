import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/incident.dart';
import '../provider/incident_provider.dart';
import '../widgets/incident_tile.dart';
import 'login_screen.dart';

class AllIncident extends StatefulWidget {
  const AllIncident({Key? key}) : super(key: key);

  static const routeName = '/all_incident';

  @override
  State<AllIncident> createState() => _AllIncidentState();
}

class _AllIncidentState extends State<AllIncident> {
  ScrollController controller = ScrollController();
  List<Incident?> myList = [];

  @override
  void dispose() {
    super.dispose();
    controller.removeListener(_scrollListener);
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<IncidentProvider>(context, listen: false).fetchAllIncident();
    });

    controller.addListener(() => _scrollListener());
  }

  _scrollListener() async {
    if (controller.position.pixels == controller.position.maxScrollExtent) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        Provider.of<IncidentProvider>(context, listen: false)
            .fetchMoreAllIncident()
            .then((value) {
          if (value == null) {
            Fluttertoast.showToast(
                msg: "No more incident to load",
                textColor: Colors.white,
                backgroundColor: Colors.red,
                toastLength: Toast.LENGTH_SHORT);
          }
        });
      });
    }
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
              : RefreshIndicator(
                  onRefresh: () => provider.fetchAllIncident(),
                  child: RawScrollbar(
                    thumbColor: Colors.grey,
                    controller: controller,
                    thickness: 1,
                    child: SingleChildScrollView(
                      controller: controller,
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
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
                              },
                            ),
                            provider.loadMoreAll
                                ? const Padding(
                                    padding: EdgeInsets.only(top: 20),
                                    child: CupertinoActivityIndicator(
                                      animating: true,
                                      radius: 12,
                                    ),
                                  )
                                : const SizedBox(),
                          ],
                        ),
                      ),
                    ),
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
