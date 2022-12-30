import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';

import '../model/incident.dart';
import '../screen/view_incident.dart';

class IncidentListTile extends StatelessWidget {
  const IncidentListTile(
      {super.key, required this.incident, required this.parentChild});

  final Incident incident;
  final String parentChild;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (builder) => ViewIncident(
            incident: incident,
            parentPage: parentChild,
          ),
        ),
      ),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.only(left: 5, right: 5, top: 6),
        child: Container(
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
          child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blue.withOpacity(.1),
                radius: 20,
                child: const Icon(
                  Ionicons.warning_outline,
                  color: Colors.blue,
                ),
              ),
              title: Text(
                incident.location.toString(),
                style: Theme.of(context).textTheme.headline6,
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      DateFormat('MMM d, yyyy HH:mm').format(
                          DateTime.parse(incident.createdAt.toString())),
                      style: Theme.of(context).textTheme.bodyLarge!.merge(
                            const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                    ),
                    // Container(
                    //   margin:
                    //       const EdgeInsets.only(bottom: 2, left: 15, right: 15),
                    //   height: 10,
                    //   width: 1,
                    //   color: Colors.grey,
                    // ),
                    // SizedBox(
                    //   width: 100,
                    //   child: Text(
                    //     incident.accidentCategory.toString(),
                    //     overflow: TextOverflow.ellipsis,
                    //     style: Theme.of(context).textTheme.bodySmall,
                    //   ),
                    // ),
                  ],
                ),
              ),
              trailing: Icon(
                incident.isViewed.toString() == "0"
                    ? Ionicons.checkmark_outline
                    : Ionicons.checkmark_done_outline,
                size: 20,
                color: incident.isViewed.toString() != "0"
                    ? Colors.blue
                    : Colors.grey,
              )),
        ),
      ),
    );
  }
}
