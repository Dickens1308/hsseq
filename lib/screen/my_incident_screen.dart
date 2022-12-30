// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../model/incident.dart';
import '../provider/incident_provider.dart';
import '../widgets/incident_tile.dart';
import 'create_incident.dart';

class MyIncidentScreen extends StatefulWidget {
  const MyIncidentScreen({Key? key}) : super(key: key);

  static const routeName = '/my_incident';

  @override
  State<MyIncidentScreen> createState() => _MyIncidentScreenState();
}

class _MyIncidentScreenState extends State<MyIncidentScreen> {
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
      Provider.of<IncidentProvider>(context, listen: false)
          .fetchMyIncident(context);
    });

    controller.addListener(() => _scrollListener());
  }

  _scrollListener() async {
    if (controller.position.pixels == controller.position.maxScrollExtent) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        Provider.of<IncidentProvider>(context, listen: false)
            .fetchMoreMyIncident()
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
        title: const Text("My Incident"),
      ),
      body: Consumer<IncidentProvider>(
        builder: (context, notify, child) {
          return notify.isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : notify.myIncidentList.isEmpty
                  ? icidentNotFound(context)
                  : bodyListView(notify, context);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, CreateIncident.routeName)
              .then((value) => {
                    if (value != null)
                      {
                        // ignore: use_build_context_synchronously
                        Provider.of<IncidentProvider>(context, listen: false)
                            .fetchMyIncident(context),
                      }
                  });
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  RefreshIndicator bodyListView(IncidentProvider notify, BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => notify.fetchMyIncident(context),
      child: RawScrollbar(
        thumbColor: Colors.grey,
        controller: controller,
        thickness: 1,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          controller: controller,
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: notify.myIncidentList.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    Incident incident = notify.myIncidentList[index];
                    return IncidentListTile(
                      incident: incident,
                      parentChild: 'my_incident',
                    );
                  },
                ),
                notify.loadMore
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
  }

  Center icidentNotFound(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(1),
            child: Text(
              "No Incident Found!",
              style: Theme.of(context).textTheme.headline5!.merge(
                    const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(1),
            child: Text(
              "Please Add Incident From + button below!",
              style: Theme.of(context).textTheme.bodyLarge!.merge(
                    const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
            ),
          )
        ],
      ),
    );
  }
}
