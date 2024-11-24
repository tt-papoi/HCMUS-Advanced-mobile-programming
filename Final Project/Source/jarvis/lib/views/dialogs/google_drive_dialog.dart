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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      title: const Row(
        children: [
          Icon(Icons.drive_folder_upload),
          SizedBox(width: 8),
          Text(
            'Google Drive',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            onTapOutside: (event) {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            controller: nameController,
            decoration: InputDecoration(
              hintStyle: const TextStyle(
                  color: Colors.black45, fontWeight: FontWeight.normal),
              labelText: "Name",
              labelStyle: const TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                  fontSize: 14),
              hintText: "Enter a name",
              filled: true,
              fillColor: const Color.fromARGB(0, 0, 0, 0),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(color: Colors.black54, width: 1.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide:
                    const BorderSide(color: Colors.blueAccent, width: 1.0),
              ),
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
              padding: const EdgeInsets.all(10),
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black54),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: selectedFile != null
                    ? Expanded(
                        child: Text(
                          'Selected file: $selectedFile',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                        ),
                      )
                    : const Expanded(
                        child: Column(
                          children: [
                            Icon(
                              Icons.upload_file,
                              color: Colors.black45,
                            ),
                            Text(
                              'Click or drag file to upload',
                              style: TextStyle(
                                  fontSize: 16, color: Colors.black54),
                            ),
                          ],
                        ),
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
