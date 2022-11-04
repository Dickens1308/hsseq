// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:hsseq/model/incident.dart';
import 'package:hsseq/provider/incident_provider.dart';
import 'package:hsseq/screen/create_incident.dart';
import 'package:provider/provider.dart';

class MyIncidentScreen extends StatefulWidget {
  const MyIncidentScreen({Key? key}) : super(key: key);

  static const routeName = '/my_incident';

  @override
  State<MyIncidentScreen> createState() => _MyIncidentScreenState();
}

class _MyIncidentScreenState extends State<MyIncidentScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<IncidentProvider>(context, listen: false)
          .fetchMyIncident(context);
    });
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
                  ? Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(1),
                            child: Text(
                              "No Incident Found!",
                              style:
                                  Theme.of(context).textTheme.headline5!.merge(
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
                              style:
                                  Theme.of(context).textTheme.bodyLarge!.merge(
                                        const TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                            ),
                          )
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: notify.myIncidentList.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        Incident incident = notify.myIncidentList[index];
                        return GestureDetector(
                          onTap: () {},
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
                                    color:
                                        const Color.fromARGB(255, 179, 179, 179)
                                            .withOpacity(.3),
                                  ),
                                ],
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor:
                                      Colors.deepPurple.withOpacity(.1),
                                  radius: 20,
                                  child: const Icon(
                                    Icons.home_outlined,
                                    color: Colors.deepPurple,
                                  ),
                                ),
                                title: Text(
                                  incident.description.toString(),
                                  style: Theme.of(context).textTheme.headline6,
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 6),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        "12/12/2022",
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
                                        margin:
                                            const EdgeInsets.only(bottom: 2),
                                        height: 10,
                                        width: 2,
                                        color: Colors.deepPurple,
                                      ),
                                      const SizedBox(width: 3),
                                      Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 2),
                                        height: 10,
                                        width: 2,
                                        color: Colors.deepPurple,
                                      ),
                                      const SizedBox(width: 3),
                                      Text(
                                        incident.happenedAt.toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1!
                                            .merge(
                                              const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: Colors.blue,
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
                                    color: Colors.deepPurple,
                                  ),
                                  onPressed: () {},
                                ),
                              ),
                            ),
                          ),
                        );
                        ;
                      });
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
}
