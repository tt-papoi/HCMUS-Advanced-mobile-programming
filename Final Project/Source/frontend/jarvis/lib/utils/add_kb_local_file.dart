import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class LocalFileDialog extends StatefulWidget {
  final Function(String name, PlatformFile file) onConnect;

  const LocalFileDialog({super.key, required this.onConnect});

  @override
  LocalFileDialogState createState() => LocalFileDialogState();
}

class LocalFileDialogState extends State<LocalFileDialog> {
  TextEditingController nameController = TextEditingController();
  PlatformFile? selectedFile;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      title: const Row(
        children: [
          Icon(Icons.upload_file),
          SizedBox(width: 8),
          Text('Local file'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Name',
              hintText: 'Enter a name for this file',
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
                  selectedFile = result.files.single;
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
                child: selectedFile != null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Selected file: ${selectedFile!.name}',
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.black54)),
                          const SizedBox(height: 8),
                          Text(
                              'Type: ${selectedFile!.extension?.toUpperCase() ?? "Unknown"}',
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.black45)),
                          Text('Size: ${_formatFileSize(selectedFile!.size)}',
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.black45)),
                        ],
                      )
                    : const Text(
                        'Click or drag file to this area to upload',
                        style: TextStyle(fontSize: 16, color: Colors.black54),
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

  String _formatFileSize(int size) {
    if (size < 1024) {
      return '$size B';
    } else if (size < 1024 * 1024) {
      return '${(size / 1024).toStringAsFixed(2)} KB';
    } else {
      return '${(size / (1024 * 1024)).toStringAsFixed(2)} MB';
    }
  }
}
