import 'package:data_logger/Screen/Service/controller.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class SaveDialog extends StatefulWidget {
  @override
  _SaveDialogState createState() => _SaveDialogState();
}

class _SaveDialogState extends State<SaveDialog> {
  TextEditingController _filePathController = TextEditingController();
  TextEditingController _fileNameController = TextEditingController();
  final HomeController ctrl = Get.put(HomeController());
  void _selectSaveLocation() async {
    final result = await FilePicker.platform.getDirectoryPath();

    if (result != null) {
      setState(() {
        _filePathController.text = result!;
      });

      print("Selected directory: ${result}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.save, size: 28, color: Color(0xff191F26)),
          SizedBox(width: 10),
          Text(
            'Save File',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
              color: Color(0xff191F26),
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTextField(
            controller: _filePathController,
            hintText: 'File Path',
            icon: Icons.folder,
            onPressed: _selectSaveLocation,
          ),
          SizedBox(height: 10),
          _buildTextField(
            controller: _fileNameController,
            labelText: 'File Name',
            isLabel: true,
          ),
          SizedBox(height: 10),
          Row(
            children: [
              _buildTextButton(
                text: 'Cancel',
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                textColor: Colors.red,
              ),
              _buildElevatedButton(
                onPressed: () {
                  // Perform save action here
                  String filePath = _filePathController.text;
                  String fileName = _fileNameController.text;

                  if (filePath.isNotEmpty && fileName.isNotEmpty) {
                    String completePath = '$filePath/$fileName';
                    ctrl.exportToExcel(filePath, fileName);
                    print('File saved to: $completePath');
                  } else {
                    print('Please enter both file path and name.');
                  }

                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
            ],
          )
        ],
      ),
      actions: [],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    String? hintText,
    String? labelText,
    IconData? icon,
    bool isLabel = false,
    VoidCallback? onPressed,
  }) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xff191F26)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                border: InputBorder.none,
                suffixIcon: onPressed != null
                    ? IconButton(
                        icon: Icon(icon, color: Color(0xff191F26)),
                        onPressed: onPressed,
                      )
                    : null,
                hintText: hintText,
                labelText: isLabel ? labelText : null,
                labelStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
                hintStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextButton({
    required String text,
    required VoidCallback onPressed,
    Color? textColor,
  }) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          color: textColor ?? Colors.black,
          fontSize: 18,
        ),
      ),
    );
  }

  Widget _buildElevatedButton({
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        primary: Color(0xff191F26),
        elevation: 0,
      ),
      child: Row(
        children: [
          Icon(Icons.save, size: 24),
          SizedBox(width: 10),
          Text(
            'Save',
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
