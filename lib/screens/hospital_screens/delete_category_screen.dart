import 'package:caresync/constants/constants.dart';
import 'package:caresync/networking/cloud_storage.dart';
import 'package:caresync/widgets/auto_complete.dart';
import 'package:caresync/widgets/main_text_button.dart';
import 'package:caresync/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import '../../constants/models.dart';
import '../../widgets/drop_down_menu.dart';

class DeleteCategoryScreen extends StatefulWidget {
  static const String id = "DeleteCategoryScreen";

  const DeleteCategoryScreen({super.key});

  @override
  State<DeleteCategoryScreen> createState() => _DeleteCategoryScreenState();
}

class _DeleteCategoryScreenState extends State<DeleteCategoryScreen> {
  bool isUploading = false;
  List<Category> categories = [];
  TextEditingController controller = TextEditingController();

  Future<void> getCategory() async {
    categories = await CloudStorage.getCategories();
    print(categories);
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
        title: const Text('Delete Category'),
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
                    setState(() {
                      controller.text = val;
                      categoryName = val;
                    });
                  },
                  isError: isError,
                  suggestions: categories.map((e) => e.name!).toList(),
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
                        categories.any((e) => e.name == categoryName)) {
                      setState(() {
                        isError = true;
                      });
                    } else {
                      setState(() {
                        isUploading = true;
                      });
                      try {
                        if (await CloudStorage.removeCategory(
                            categoryName, context)) {
                          kSnackBar("Category $categoryName deleted", context);
                        } else {
                          kSnackBar(
                            "Error Deleting $categoryName category",
                            context,
                          );
                        }
                      } catch (e) {
                        kSnackBar(e.toString(), context);
                      }
                      setState(() {
                        isUploading = false;
                      });
                    }
                  },
                  title: "Delete Category",
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
