import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fruitapp/controllers/fruit_controller.dart';
import 'package:image_picker/image_picker.dart';
import 'package:unicons/unicons.dart';

class SaveFuit extends StatefulWidget {
  const SaveFuit({Key? key}) : super(key: key);

  @override
  State<SaveFuit> createState() => _SaveFuitState();
}

class _SaveFuitState extends State<SaveFuit> {
  final PostController _postController = PostController();

  final TextEditingController _postTxtController = TextEditingController();

  final ImagePicker _imagePicker = ImagePicker();

  bool isLoading = false;

  File? _imagePostFile;

  selectImage(ImageSource imageSource) async {
    XFile? selectedFile = await _imagePicker.pickImage(source: imageSource);
    setState(() {
      _imagePostFile = File(selectedFile!.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text(
          "Create a post",
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text("Please select an image"),
          const SizedBox(
            height: 20,
          ),
          InkWell(
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              selectImage(ImageSource.camera);
                            },
                            icon: const Icon(UniconsLine.camera),
                            label: const Text("Select from camera"),
                          ),
                          const Divider(),
                          TextButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              selectImage(ImageSource.gallery);
                            },
                            icon: const Icon(UniconsLine.picture),
                            label: const Text("Select from gallery"),
                          ),
                        ],
                      );
                    });
              },
              child: _imagePostFile == null
                  ? Image.asset(
                      "assets/placeholder.jpeg",
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.cover,
                    )
                  : Image.file(
                      _imagePostFile!,
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.cover,
                    )),
          const SizedBox(
            height: 20,
          ),
          TextField(
            controller: _postTxtController,
            decoration: InputDecoration(
                hintText: "name of the fruit",
                hintStyle: const TextStyle(color: Colors.grey),
                label: Text(
                  "Name",
                  style: Theme.of(context).textTheme.bodyText1,
                )),
          ),
          const SizedBox(
            height: 20,
          ),
          isLoading
              ? const Center(child: CircularProgressIndicator.adaptive())
              : TextButton(
                  onPressed: () async {
                    if (_imagePostFile != null) {
                      setState(() {
                        isLoading = true;
                      });
                      bool isSubmitted = await _postController.createPost(
                          postImage: _imagePostFile!,
                          name: _postTxtController.text);
                      setState(() {
                        isLoading = true;
                      });
                      if (isSubmitted) {
                        Fluttertoast.showToast(
                            msg: _postController.message,
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.green,
                            textColor: Colors.white,
                            fontSize: 16.0);
                        Navigator.pop(context);
                      }
                    } else {
                      Fluttertoast.showToast(
                          msg: "no image selected",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    }
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: const Text(
                    "Save Fruit",
                    style: TextStyle(color: Colors.white),
                  ))
        ],
      ),
    );
  }
}
