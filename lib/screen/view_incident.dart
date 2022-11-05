// ignore_for_file: depend_on_referenced_packages

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hsseq/model/incident.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:hsseq/provider/incident_provider.dart';
import 'package:hsseq/screen/edit_incident.dart';
import 'package:hsseq/screen/image_view.dart';
import 'package:hsseq/screen/update_images.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:intl/intl.dart';

enum IncidentAction { edit, delete, updateImages }

class ViewIncident extends StatefulWidget {
  const ViewIncident(
      {Key? key, required this.incident, required this.parentPage})
      : super(key: key);

  final Incident incident;
  final String parentPage;

  @override
  State<ViewIncident> createState() => _ViewIncidentState();
}

class _ViewIncidentState extends State<ViewIncident> {
  // For Caching Images & Storing locally
  static final customCacheManager = CacheManager(
    Config(
      'customCacheKey',
      maxNrOfCacheObjects: 200,
      stalePeriod: const Duration(days: 2),
    ),
  );

  late Incident incident;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    incident = widget.incident;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text("Incident Details"),
        actions: [
          widget.parentPage == "all_incident"
              ? popupForAllIncidentWithoutUpdate(context)
              : incident.isViewed.toString() == "0"
                  ? popupForMyIncident(context)
                  : popupForMyIncidentWitoutDelete(context)
        ],
      ),
      body: Consumer<IncidentProvider>(builder: (context, notify, child) {
        return notify.isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              spreadRadius: .4,
                              blurRadius: .4,
                              offset: const Offset(1, 0),
                              color: const Color.fromARGB(255, 179, 179, 179)
                                  .withOpacity(.3),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              detailsColumn(
                                  "Location: ", incident.location.toString()),
                              detailsColumn("Description: ",
                                  incident.description.toString()),
                              detailsColumn("Risk Level: ",
                                  incident.riskLevel.toString()),
                              detailsColumn("Action Taken: ",
                                  incident.immediateActionTaken.toString()),
                              detailsColumn("Reported By: ",
                                  incident.reporter!.name.toString()),
                              detailsColumn(
                                "Reported Date",
                                DateFormat('MMMM d, yyyy HH:mm').format(
                                    DateTime.parse(
                                        incident.createdAt.toString())),
                              ),
                            ],
                          ),
                        ),
                      ),
                      incident.images!.isNotEmpty
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(bottom: 8, top: 8),
                                  child: Text(
                                    "Incident Images",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline5!
                                        .merge(
                                          const TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                  ),
                                ),
                                Container(
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
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      top: 2,
                                      left: 8,
                                      bottom: 6,
                                    ),
                                    child: newMethod(),
                                  ),
                                ),
                              ],
                            )
                          : Container(),
                    ],
                  ),
                ),
              );
      }),
    );
  }

  PopupMenuButton<IncidentAction> popupForMyIncident(BuildContext context) {
    return PopupMenuButton(
        position: PopupMenuPosition.under,
        itemBuilder: (context) {
          return [
            PopupMenuItem<IncidentAction>(
              value: IncidentAction.edit,
              child: Row(
                children: const [
                  Icon(Icons.edit, color: Colors.grey),
                  Padding(
                    padding: EdgeInsets.only(left: 5),
                    child: Text("Update Incident"),
                  ),
                ],
              ),
            ),
            PopupMenuItem<IncidentAction>(
              value: IncidentAction.updateImages,
              child: Row(
                children: const [
                  Icon(Icons.image, color: Colors.grey),
                  Padding(
                    padding: EdgeInsets.only(left: 5),
                    child: Text("Update Images"),
                  ),
                ],
              ),
            ),
            PopupMenuItem<IncidentAction>(
              value: IncidentAction.delete,
              child: Row(
                children: const [
                  Icon(Icons.delete_outline, color: Colors.grey),
                  Padding(
                    padding: EdgeInsets.only(left: 5),
                    child: Text("Delete Incident"),
                  ),
                ],
              ),
            ),
          ];
        },
        onSelected: (value) {
          if (value == IncidentAction.edit) {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditIncident(incident: incident),
                )).then((value) => {
                  if (value != null)
                    {
                      setState(() {
                        incident = value;
                      }),
                    }
                });
          } else if (value == IncidentAction.updateImages) {
            Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => UpdateImages(incident: incident)))
                .then((value) => {
                      if (value != null)
                        {
                          setState(
                            () {
                              incident = value;
                            },
                          )
                        }
                    });
          } else if (value == IncidentAction.delete) {
            showDialogBoxWidget(context);
          }
        });
  }

  PopupMenuButton<IncidentAction> popupForAllIncidentWithoutUpdate(
      BuildContext context) {
    return PopupMenuButton(
        position: PopupMenuPosition.under,
        itemBuilder: (context) {
          return [
            PopupMenuItem<IncidentAction>(
              value: IncidentAction.delete,
              child: Row(
                children: const [
                  Icon(Icons.delete_outline, color: Colors.grey),
                  Padding(
                    padding: EdgeInsets.only(left: 5),
                    child: Text("Delete Incident"),
                  ),
                ],
              ),
            ),
          ];
        },
        onSelected: (value) {
          if (value == IncidentAction.delete) {
            showDialogBoxWidget(context);
          }
        });
  }

  PopupMenuButton<IncidentAction> popupForMyIncidentWitoutDelete(
      BuildContext context) {
    return PopupMenuButton(
        position: PopupMenuPosition.under,
        itemBuilder: (context) {
          return [
            PopupMenuItem<IncidentAction>(
              value: IncidentAction.edit,
              child: Row(
                children: const [
                  Icon(Icons.edit, color: Colors.grey),
                  Padding(
                    padding: EdgeInsets.only(left: 5),
                    child: Text("Update Incident"),
                  ),
                ],
              ),
            ),
            PopupMenuItem<IncidentAction>(
              value: IncidentAction.updateImages,
              child: Row(
                children: const [
                  Icon(Icons.image, color: Colors.grey),
                  Padding(
                    padding: EdgeInsets.only(left: 5),
                    child: Text("Update Images"),
                  ),
                ],
              ),
            ),
          ];
        },
        onSelected: (value) {
          if (value == IncidentAction.edit) {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditIncident(incident: incident),
                )).then((value) => {
                  if (value != null)
                    {
                      setState(() {
                        incident = value;
                      }),
                    }
                });
          } else if (value == IncidentAction.updateImages) {
            Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => UpdateImages(incident: incident)))
                .then((value) => {
                      if (value != null)
                        {
                          setState(
                            () {
                              incident = value;
                            },
                          )
                        }
                    });
          }
        });
  }

  GridView newMethod() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemCount: incident.images!.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: (() => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      PhotoFullScreenView(image: incident.images![index].path),
                ),
              )),
          child: Padding(
            padding: const EdgeInsets.only(right: 10, top: 10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                cacheManager: customCacheManager,
                key: UniqueKey(),
                imageUrl: incident.images![index].path.toString(),
                height: MediaQuery.of(context).size.height * .12,
                width: MediaQuery.of(context).size.width * .25,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) {
                  return Image.asset('assets/images/error.jpg');
                },
                placeholder: (context, url) {
                  return Shimmer.fromColors(
                    baseColor: Colors.grey.withOpacity(.3),
                    highlightColor: Colors.white.withOpacity(.2),
                    child: Container(
                      height: MediaQuery.of(context).size.height * .12,
                      width: MediaQuery.of(context).size.width * .25,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget detailsColumn(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$title:",
            textAlign: TextAlign.justify,
            style: Theme.of(context).textTheme.bodyText1,
          ),
          Text(
            value,
            textAlign: TextAlign.justify,
            style: Theme.of(context).textTheme.headline6,
          ),
        ],
      ),
    );
  }

  void showDialogBoxWidget(buildContextcontext) {
    showDialog(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            title: const Text("Are you sure want to delete?"),
            content: const Text(
                "You're trying to deleting incident, please make sure you know what you're trying to do!"),
            actions: [
              TextButton(
                onPressed: () => {
                  Navigator.of(dialogContext).pop(true),
                  log("message"),
                  Provider.of<IncidentProvider>(context, listen: false)
                      .deleteIncident(context, incident.id)
                },
                child: const Text("Delete anyway!"),
              ),
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(false),
                child: const Text(
                  "Cancel",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              )
            ],
          );
        });
  }

  // static String displayTimeAgoFromTimestamp(
  //     String dateString, bool numericDates) {
  //   DateTime date = DateTime.parse(dateString);
  //   final date2 = DateTime.now();
  //   final difference = date2.difference(date);

  //   if ((difference.inDays / 365).floor() >= 2) {
  //     return '${(difference.inDays / 365).floor()} years ago';
  //   } else if ((difference.inDays / 365).floor() >= 1) {
  //     return (numericDates) ? '1 year ago' : 'Last year';
  //   } else if ((difference.inDays / 30).floor() >= 2) {
  //     return '${(difference.inDays / 365).floor()} months ago';
  //   } else if ((difference.inDays / 30).floor() >= 1) {
  //     return (numericDates) ? '1 month ago' : 'Last month';
  //   } else if ((difference.inDays / 7).floor() >= 2) {
  //     return '${(difference.inDays / 7).floor()} weeks ago';
  //   } else if ((difference.inDays / 7).floor() >= 1) {
  //     return (numericDates) ? '1 week ago' : 'Last week';
  //   } else if (difference.inDays >= 2) {
  //     return '${difference.inDays} days ago';
  //   } else if (difference.inDays >= 1) {
  //     return (numericDates) ? '1 day ago' : 'Yesterday';
  //   } else if (difference.inHours >= 2) {
  //     return '${difference.inHours} hours ago';
  //   } else if (difference.inHours >= 1) {
  //     return (numericDates) ? '1 hour ago' : 'An hour ago';
  //   } else if (difference.inMinutes >= 2) {
  //     return '${difference.inMinutes} minutes ago';
  //   } else if (difference.inMinutes >= 1) {
  //     return (numericDates) ? '1 minute ago' : 'A minute ago';
  //   } else if (difference.inSeconds >= 3) {
  //     return '${difference.inSeconds} seconds ago';
  //   } else {
  //     return 'Just now';
  //   }
  // }
}
