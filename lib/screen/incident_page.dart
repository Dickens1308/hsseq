import 'package:flutter/material.dart';
import 'package:hsseq/model/incident.dart';
import 'package:hsseq/provider/incident_provider.dart';
import 'package:hsseq/screen/login_screen.dart';
import 'package:provider/provider.dart';

// ignore: depend_on_referenced_packages
import 'package:shared_preferences/shared_preferences.dart';

class IncidentPage extends StatefulWidget {
  const IncidentPage({Key? key}) : super(key: key);

  static const routeName = '/incident';

  @override
  State<IncidentPage> createState() => _IncidentPageState();
}

class _IncidentPageState extends State<IncidentPage> {
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
        title: const Text("Incident"),
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () => saveTokenPref(),
              icon: const Icon(Icons.logout_outlined))
        ],
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

                            return Padding(
                              padding: const EdgeInsets.all(10),
                              child: ListTile(
                                leading: const CircleAvatar(
                                  backgroundColor: Colors.blue,
                                  radius: 30,
                                ),
                                title: Text(
                                  incident.description.toString(),
                                  maxLines: 2,
                                ),
                                trailing: IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.delete_outline),
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
