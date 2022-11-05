// ignore_for_file: depend_on_referenced_packages

import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hsseq/model/incident.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:hsseq/provider/incident_provider.dart';
import 'package:hsseq/screen/image_view.dart';
import 'package:shimmer/shimmer.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class UpdateImages extends StatefulWidget {
  const UpdateImages({super.key, required this.incident});
  final Incident incident;

  @override
  State<UpdateImages> createState() => _UpdateImagesState();
}

class _UpdateImagesState extends State<UpdateImages> {
  late Incident incident;

  // For Caching Images & Storing locally
  static final customCacheManager = CacheManager(
    Config(
      'customCacheKey',
      maxNrOfCacheObjects: 200,
      stalePeriod: const Duration(days: 2),
    ),
  );

  //Image Upload Variables & Methods
  final ImagePicker imagePicker = ImagePicker();
  List<XFile>? imageFiles = [];

  openImageGallery() async {
    try {
      var isPermissionAllowed = await _checkPermission();
      final List<XFile>? pickedFiles =
          isPermissionAllowed ? await imagePicker.pickMultiImage() : null;
      if (pickedFiles != null) {
        setState(() {
          imageFiles!.addAll(pickedFiles);
        });
      } else {
        _toasterMessage("No image file selected", Colors.red);
        log("No image is selected.");
      }
    } catch (e) {
      log(e.toString());
    }
  }

  openCameraGallery() async {
    try {
      var isPermissionAllowed = await _checkCameraPermission();
      XFile? pickedFiles = isPermissionAllowed
          ? await imagePicker.pickImage(source: ImageSource.camera)
          : null;
      if (pickedFiles != null) {
        setState(() {
          imageFiles!.add(pickedFiles);
        });
      } else {
        _toasterMessage("No image file selected", Colors.blue);
        log("No image is selected.");
      }
    } catch (e) {
      log(e.toString());
    }
  }

  late int _selectedPhoto;

  @override
  void initState() {
    super.initState();
    incident = widget.incident;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Incident Photos"),
      ),
      body: Consumer<IncidentProvider>(builder: (context, notify, child) {
        return notify.isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: OutlinedButton(
                          onPressed: () => openCameraGallery(),
                          child: const Padding(
                            padding: EdgeInsets.only(top: 10, bottom: 10),
                            child: Text("Upload By Camera"),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: OutlinedButton(
                          onPressed: () => openImageGallery(),
                          child: const Padding(
                            padding: EdgeInsets.only(top: 10, bottom: 10),
                            child: Text("Upload From File"),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      imageFiles != null
                          ? Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: buildGridView(),
                            )
                          : const SizedBox(height: 8),
                      imageFromServerGrid(incident, notify),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            notify.addMorePhotoToIncident(
                                context, incident.id, imageFiles!);
                          },
                          child: const Padding(
                            padding: EdgeInsets.only(top: 10, bottom: 10),
                            child: Text("Save Incident"),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
      }),
    );
  }

  Widget buildGridView() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemCount: imageFiles!.length,
      itemBuilder: (context, index) {
        return Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Container(
                height: MediaQuery.of(context).size.height * .22,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  image: DecorationImage(
                    image: FileImage(File(imageFiles![index].path)),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.2), BlendMode.darken),
                  ),
                ),
              ),
            ),
            Positioned(
              right: 10,
              top: 10,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    imageFiles!
                        .removeWhere((e) => e.path == imageFiles![index].path);
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.red.shade300,
                  ),
                  width: 30,
                  height: 30,
                  child: const Icon(
                    Icons.close,
                    size: 22,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget imageFromServerGrid(Incident incident, IncidentProvider notify) {
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
            child: Container(
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
              child: Stack(
                children: [
                  SizedBox(
                    height: double.infinity,
                    width: double.infinity,
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
                  Positioned(
                    right: 10,
                    top: 10,
                    child: GestureDetector(
                      onTap: () {
                        _selectedPhoto = index;

                        notify
                            .deleteIncedentPhoto(context, incident.id,
                                incident.images![index].id)
                            .then((value) {
                          setState(() {
                            if (value != null) {
                              incident = value;
                            }
                          });
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          color: Colors.red.shade300,
                        ),
                        width: 30,
                        height: 30,
                        child:
                            (notify.isDeleteLoading && index == _selectedPhoto)
                                ? const Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(3.0),
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2, color: Colors.white),
                                    ),
                                  )
                                : const Icon(
                                    Icons.close,
                                    size: 22,
                                    color: Colors.white,
                                  ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<bool> _checkPermission() async {
    Map<Permission, PermissionStatus> status =
        await [Permission.storage].request();

    if (status[Permission.storage]!.isGranted) {
      return true;
    } else {
      _toasterMessage("Permission Denied!", Colors.red);
      return false;
    }
  }

  Future<bool> _checkCameraPermission() async {
    Map<Permission, PermissionStatus> status =
        await [Permission.camera].request();

    if (status[Permission.camera]!.isGranted) {
      return true;
    } else {
      _toasterMessage("Failed to open camera!", Colors.red);
      return false;
    }
  }

  void _toasterMessage(String msg, Color colors) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: colors,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
