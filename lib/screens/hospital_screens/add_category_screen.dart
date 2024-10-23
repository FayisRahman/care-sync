import 'package:caresync/constants/constants.dart';
import 'package:caresync/networking/cloud_storage.dart';
import 'package:caresync/widgets/auto_complete.dart';
import 'package:caresync/widgets/main_text_button.dart';
import 'package:caresync/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import '../../widgets/drop_down_menu.dart';

class AddCategoryScreen extends StatefulWidget {
  static const String id = "AddCategoryScreen";

  const AddCategoryScreen({super.key});

  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  bool isUploading = false;
  List<String> categories = [];
  TextEditingController controller = TextEditingController();

  Future<void> getCategory() async {
    categories = await CloudStorage.getCategories();
  }

  bool isError = false;
  String categoryName = "";

  @override
  void initState() {
    super.initState();
    getCategory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Category'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                AutoCompleteField(
                  controller: controller,
                  title: "Category Name",
                  onSuggestionSelected: (val) {
                    controller.text = val;
                    categoryName = val;
                  },
                  isError: isError,
                  suggestions: categories,
                  type: "category",
                  onChanged: (val) {
                    setState(() {
                      categoryName = val;
                      isError = false;
                    });
                  },
                  isRequired: true,
                ),
                const SizedBox(height: 20),
                MainTextButton(
                  onPressed: () async {
                    if (categoryName.isEmpty ||
                        categories.contains(categoryName)) {
                      setState(() {
                        isError = true;
                      });
                    } else {
                      setState(() {
                        isUploading = true;
                      });
                      try {
                        await CloudStorage.addCategory(categoryName);
                        kSnackBar("Category $categoryName uploaded", context);
                      } catch (e) {
                        kSnackBar(e.toString(), context);
                      }
                      setState(() {
                        isUploading = false;
                      });
                    }
                  },
                  title: "Add Category",
                  isLoad: isUploading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
