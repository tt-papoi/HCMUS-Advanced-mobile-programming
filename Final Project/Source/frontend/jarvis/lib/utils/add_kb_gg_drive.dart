import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class GoogleDriveDialog extends StatefulWidget {
  final Function(String name, String fileName) onConnect;

  const GoogleDriveDialog({super.key, required this.onConnect});

  @override
  GoogleDriveDialogState createState() => GoogleDriveDialogState();
}

class GoogleDriveDialogState extends State<GoogleDriveDialog> {
  TextEditingController nameController = TextEditingController();
  String? selectedFile;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      title: const Row(
        children: [
          Icon(Icons.drive_folder_upload),
          SizedBox(width: 8),
          Text('Google Drive'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Name',
              hintText: 'Enter your name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () async {
              final result =
                  await FilePicker.platform.pickFiles(type: FileType.any);
              if (result != null && result.files.isNotEmpty) {
                setState(() {
                  selectedFile = result.files.single.name;
                });
              }
            },
            child: Container(
              height: 100,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  selectedFile != null
                      ? 'Selected file: $selectedFile'
                      : 'Click or drag file to this area to upload',
                  style: const TextStyle(fontSize: 16, color: Colors.black54),
                ),
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (nameController.text.isNotEmpty && selectedFile != null) {
              widget.onConnect(nameController.text, selectedFile!);
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Connected successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
            }
          },
          child: const Text('Connect'),
        ),
      ],
    );
  }
}
