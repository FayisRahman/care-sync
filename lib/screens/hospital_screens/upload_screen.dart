import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:caresync/constants/constants.dart';
import 'package:caresync/networking/cloud_storage.dart';
import 'package:caresync/widgets/data_report_field.dart';
import 'package:caresync/widgets/drop_down_menu.dart';
import 'package:caresync/widgets/main_text_button.dart';
import 'package:caresync/widgets/text_field.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

import '../../constants/models.dart';

class UploadScreen extends StatefulWidget {
  static const String id = "UploadScreen";

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  final ImagePicker _picker = ImagePicker();
  File? _documentFile;
  bool _isUploading = false;
  String? _imageUrl;
  String pno = "";
  String type = "";
  final _auth = FirebaseAuth.instance;
  final TextEditingController _nameController = TextEditingController();
  String typeValue = "";
  String name = "";
  List<String> users = [];
  List<Category> categories = [];
  Map<String, int> mapVal = {"BP": 0, "Cholesterol": 1, "Sugar": 2};
  List<String> categoryList = [];
  List<TextEditingController> typeControllers = [];
  List<DataReportField> fields = [];
  List<String> values = [];
  List<String> types = [];
  String valRes = "";
  String typeRes = "";
  DateTime selectedDateTime = DateTime.now();
  Map<String, int> vals = {};

  Future<void> _pickDocument() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ["pdf"],
    );

    if (result != null) {
      setState(() {
        _documentFile = File(result.files.single.path!);
      });
      if (result.files.single.extension != "pdf") {
        kSnackBar("Please upload only pdfs", context);
        return;
      }
      _uploadDocumentToFirebase(result.files.single.extension!);
    }
  }

  void createMap() {
    vals = {};
    for (int i = 0; i < fields.length; i++) {
      if (values[i].isNotEmpty) {
        vals[types[i]] = int.parse(values[i]);
      }
    }
  }

  Future<void> _uploadDocumentToFirebase(String docType) async {
    if (_documentFile == null) return;

    setState(() {
      _isUploading = true;
    });

    try {
      String fileName =
          'userReports/$pno/${selectedDateTime.millisecondsSinceEpoch}';
      print(fileName);
      Reference firebaseStorageRef =
          FirebaseStorage.instance.ref().child(fileName);

      UploadTask uploadTask = firebaseStorageRef.putFile(_documentFile!);
      TaskSnapshot taskSnapshot = await uploadTask;

      String downloadUrl = await taskSnapshot.ref.getDownloadURL();

      setState(() {
        _imageUrl = downloadUrl;
      });
      createMap();
      await CloudStorage.addImageUrl(
          pno, downloadUrl, fileName.split("/")[2], vals, context);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Upload successful!'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Upload failed: $e'),
        ),
      );
    }

    setState(() {
      _isUploading = false;
    });
  }

  Future<void> initialise() async {
    await addCategories();
    await getUserData();
    addField();
    setState(() {
      users;
    });
  }

  Future<void> getUserData() async {
    users.clear();
    for (var doc in await CloudStorage.getAllUsers(context)) {
      users.add(doc.id);
    }
  }

  // void convertToString() {
  //   valRes = "";
  //   typeRes = "";
  //   for (String val in values) {
  //     if (valRes.isNotEmpty) {
  //       valRes += ",${val.trim()}";
  //     } else {
  //       valRes += val.trim();
  //     }
  //   }
  //   for (String val in types) {
  //     if (typeRes.isNotEmpty) {
  //       typeRes += ",${mapVal[val]}";
  //     } else {
  //       typeRes += "${mapVal[val]}";
  //     }
  //   }
  // }

  void addField() {
    typeControllers.add(TextEditingController());
    values.add("");
    types.add("");
    int currIndex = values.length - 1;
    fields.add(
      DataReportField(
        typeController: typeControllers[currIndex],
        categories: categoryList,
        selectedTypes: types,
        onSelected: (val) {
          typeControllers[currIndex].text = val;
          types[currIndex] = val;
          setState(() {
            types;
          });
        },
        onChanged: (val) {
          values[currIndex] = val;
        },
      ),
    );
    setState(() {
      fields;
    });
  }

  Future<void> addCategories() async {
    categories = await CloudStorage.getCategories();
    for (int i = 0; i < categories.length; i++) {
      categoryList.add(categories[i].name!);
    }
    print(categories);
    setState(() {
      categories;
      mapVal;
    });
  }

  Future<void> pickTime() async {
    final res = await showTimePicker(
      initialTime: TimeOfDay.fromDateTime(selectedDateTime),
      context: context,
    );
  }

  @override
  void initState() {
    super.initState();
    addCategories();
    getUserData();
    addField();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Reports'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 17),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                LoginField(
                  title: "user ID",
                  onChanged: (String val) {},
                  readOnly: true,
                  errorText: "",
                  keyboardType: TextInputType.multiline,
                  controller: _nameController,
                  child: DropDownIconButton(
                      categories: users,
                      onSelected: (String val) {
                        pno = val;
                        _nameController.text = val;
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Upload Date: ",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          backgroundColor: Colors.grey[300],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () async {
                          List<DateTime?>? results =
                              await showCalendarDatePicker2Dialog(
                            context: context,
                            config:
                                CalendarDatePicker2WithActionButtonsConfig(),
                            dialogSize: const Size(325, 400),
                            value: [],
                            borderRadius: BorderRadius.circular(15),
                          );
                          if (results != null) {
                            setState(() {
                              selectedDateTime = results[0]!;
                            });
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Text(
                            kGetDate(selectedDateTime),
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: fields,
                ),
                TextButton(
                  onPressed: () {
                    if (categories.length - types.length > 0) {
                      addField();
                    } else {
                      Fluttertoast.showToast(msg: "no category left");
                    }
                  },
                  child: const Row(
                    children: [
                      Text("+"),
                      Text("Add more"),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                MainTextButton(
                  onPressed: () async {
                    await _pickDocument();
                  },
                  title: "Upload Report",
                  isLoad: _isUploading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
