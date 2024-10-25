import 'package:flutter/material.dart';
import 'package:jarvis/models/knowledge_source.dart';
import 'package:jarvis/utils/add_kb_confluence.dart';
import 'package:jarvis/utils/add_kb_gg_drive.dart';
import 'package:jarvis/utils/add_kb_local_file.dart';
import 'package:jarvis/utils/add_kb_slack.dart';
import 'package:jarvis/utils/add_kb_web.dart';

class EditKnowledgeSourceScreen extends StatefulWidget {
  final KnowledgeSource knowledgeSource;

  const EditKnowledgeSourceScreen({super.key, required this.knowledgeSource});

  @override
  State<EditKnowledgeSourceScreen> createState() =>
      _EditKnowledgeSourceScreenState();
}

class _EditKnowledgeSourceScreenState extends State<EditKnowledgeSourceScreen> {
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  List<Unit> units = [];

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.knowledgeSource.name);
    descriptionController =
        TextEditingController(text: widget.knowledgeSource.description);
    units = widget.knowledgeSource.units ?? [];
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void _saveKnowledgeSource() {
    setState(() {
      widget.knowledgeSource.name = nameController.text;
      widget.knowledgeSource.description = descriptionController.text;
      widget.knowledgeSource.units = units;
    });

    Navigator.of(context).pop(widget.knowledgeSource);
  }

  void _showLocalFileDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return LocalFileDialog(
          onConnect: (name, file) {
            setState(() {
              units.add(Unit(
                id: DateTime.now().toString(),
                name: name,
                unitType: UnitType.localfile,
              ));
            });
          },
        );
      },
    );
  }

  void _showGoogleDriveDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return GoogleDriveDialog(
          onConnect: (name, fileName) {
            setState(() {
              units.add(Unit(
                id: DateTime.now().toString(),
                name: name,
                unitType: UnitType.googleDrive,
              ));
            });
          },
        );
      },
    );
  }

  void _showWebsiteDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return WebsiteDialog(
          onConnect: (name, url) {
            setState(() {
              units.add(Unit(
                id: DateTime.now().toString(),
                name: name,
                unitType: UnitType.website,
              ));
            });
          },
        );
      },
    );
  }

  void _showConfluenceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfluenceDialog(
          onConnect: (name, url, username, token) {
            setState(() {
              units.add(Unit(
                id: DateTime.now().toString(),
                name: name,
                unitType: UnitType.confluence,
              ));
            });
          },
        );
      },
    );
  }

  void _showSlackDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SlackDialog(
          onConnect: (name, workspace, token) {
            setState(() {
              units.add(Unit(
                id: DateTime.now().toString(),
                name: name,
                unitType: UnitType.slack,
              ));
            });
          },
        );
      },
    );
  }

  void _showKnowledgeSourceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text(
            'Add Data Sources',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.upload_file),
                title: const Text('Local files'),
                onTap: () {
                  Navigator.of(context).pop();
                  _showLocalFileDialog(); // Show local file dialog
                },
              ),
              ListTile(
                leading: const Icon(Icons.language),
                title: const Text('Website'),
                onTap: () {
                  Navigator.of(context).pop();
                  _showWebsiteDialog();
                },
              ),
              ListTile(
                leading: const Icon(Icons.code),
                title: const Text('Confluence'),
                onTap: () {
                  Navigator.of(context).pop();
                  _showConfluenceDialog();
                },
              ),
              ListTile(
                leading: const Icon(Icons.drive_folder_upload),
                title: const Text('Google Drive'),
                onTap: () {
                  Navigator.of(context).pop();
                  _showGoogleDriveDialog(); // Show Google Drive dialog
                },
              ),
              ListTile(
                leading: const Icon(Icons.folder),
                title: const Text('Slack'),
                onTap: () {
                  Navigator.of(context).pop();
                  _showSlackDialog();
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (!mounted) return;
                Navigator.of(context).pop();
              },
              child: const Text(
                'Close',
                style: TextStyle(color: Colors.black45),
              ),
            ),
          ],
        );
      },
    );
  }

  void _removeUnit(Unit unit) {
    setState(() {
      units.remove(unit);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: const Text(
          'Edit Knowledge Source',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Name field
            RichText(
              text: const TextSpan(
                text: 'Name',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.black),
                children: [
                  TextSpan(
                    text: ' *',
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              minLines: 1,
              maxLines: null,
              controller: nameController,
              decoration: InputDecoration(
                hintStyle: const TextStyle(
                    color: Colors.black45, fontWeight: FontWeight.normal),
                labelStyle: const TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                    fontSize: 14),
                hintText: '4–20 characters',
                filled: true,
                fillColor: const Color.fromARGB(0, 0, 0, 0),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide:
                      const BorderSide(color: Colors.black54, width: 1.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide:
                      const BorderSide(color: Colors.blueAccent, width: 1.0),
                ),
              ),
              onTapOutside: (event) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
            ),
            const SizedBox(height: 16),
            // Description field
            RichText(
              text: const TextSpan(
                text: 'Description',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.black),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                hintStyle: const TextStyle(
                    color: Colors.black45, fontWeight: FontWeight.normal),
                labelStyle: const TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                    fontSize: 14),
                filled: true,
                fillColor: const Color.fromARGB(0, 0, 0, 0),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide:
                      const BorderSide(color: Colors.black54, width: 1.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide:
                      const BorderSide(color: Colors.blueAccent, width: 1.0),
                ),
              ),
              onTapOutside: (event) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
            ),
            const SizedBox(height: 16),
            // Unit List
            RichText(
              text: const TextSpan(
                text: 'Units',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.black),
              ),
            ),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              itemCount: units.length,
              itemBuilder: (context, index) {
                final unit = units[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  child: ListTile(
                    leading: Icon(
                      unit.unitType == UnitType.localfile
                          ? Icons.insert_drive_file
                          : unit.unitType == UnitType.googleDrive
                              ? Icons.drive_folder_upload
                              : unit.unitType == UnitType.slack
                                  ? Icons.folder
                                  : unit.unitType == UnitType.website
                                      ? Icons.language
                                      : unit.unitType == UnitType.confluence
                                          ? Icons.code
                                          : Icons.help,
                      color: Colors.blue,
                    ),
                    title: Text(
                      unit.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      {
                            "localfile": "Local File",
                            "googledrive": "Google Drive",
                            "slack": "Slack",
                            "website": "Website",
                            "confluence": "Confluence"
                          }[unit.unitType.toString().split('.').last] ??
                          unit.unitType.toString().split('.').last,
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Switch(
                          value: unit.isEnabled ??
                              false, // Assuming you have isEnabled in Unit class
                          activeColor: Colors.blueAccent, // Màu khi bật
                          inactiveThumbColor: Colors.blueAccent,
                          onChanged: (bool value) {
                            setState(() {
                              unit.isEnabled = value;
                            });
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.black54),
                          onPressed: () => _removeUnit(unit),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: _showKnowledgeSourceDialog,
              icon: const Icon(Icons.add),
              label: const Text('Add Unit'),
            ),
            const SizedBox(height: 16),
            // Save button
            InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: _saveKnowledgeSource,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.blueAccent,
                ),
                child: const Center(
                  child: Text(
                    'Save Knowledge Source',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
